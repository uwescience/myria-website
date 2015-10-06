# Overview of the architecture

* Design philosophy?

The MyriaX execution layer is modeled after the [Actor Model](http://en.wikipedia.org/wiki/Actor_model). But it is not a general purpose Actor Model implementation. It does not allow creation of new actors by existing actors. It allows only relational data as messages. And it restricts the processing of the messages by only using the Operator interface.

# Components

* [[MyriaX REST API]]

* [[MyriaX Query Plans]]

* [[Special Features]]
    * [[Expression library]]
    * [[Profiler]]
    * [[StatefulApply]]
    * [[UserDefinedAggregates]]

* [[MyriaX Query Execution]]
    * [[Tuple batches]]
    * [[Control flow]]
    * [[EOS/EOI semantics]]
    * [[Memory management]]
    * [[Networking layer]]
    * [[Failure handling]]

Query Execution
-------------

### Operators: data processing units
Operators are MyriaX's data processing units. Each operator has a set of children operators (may be 0). Relational data (in format of TupleBatch) are drawn from the children operators (i.e. the inputs of the operator). Output relational data can be drawn by calling
 > Operator.fetchNextReady().

Each operator can have a set of children operators, but only one or zero parent operator. In this way, operators can be linked together to form an operator tree. 

#### Initialization and cleanup.
Before data processing, an Operator must be initialized, by calling
>Operator.open()

This method in turn calls
> Operator.init()

It is a method that is required to be implemented by the Operator developers to do actual initialization. It may include memory allocation, system resource reservation, etc. 

Once an operator is opend by the MyriaX system, it is guarranted that the Operator's
>Operator.close()

method will be called after the execution of the Operator, either successfully or erroneously. And in turn
> Operator.cleanup()

is called . The Operator developer should do exactly the opposite of init in the cleanup method.

#### RootOperator and LeafOperator

A RootOperator is an operator without parent. Each operator tree must be rooted by a RootOperator. RootOperator is the single location where the relational data leaves the computing system. Currently, there are SinkRoot which simply drop everything, Insert which inserts the data drawn from its child into a database, and Producer ( and its children classes) which transfers data to remote operators.

LeafOperator are the leafs of operator trees. There are also several implementations of LeafOperator, including DbScan which scans relational data from database tables, FileScan which scans relational data from local data files.

#### States
Each Operator has a EOS state variable. An Operator should execute and process data only if the EOS state is not true. If the EOS state becomes true, the Operator no longer process any data. It may still return data because it may maintain an output data buffer.


### Operator trees: execution units

A tree of operators rooted by a RootOperator is the basic execution unit of MyriaX.

<pre sytle="font-family: Consolas,monospace">
                          +------------+                
                          |            |                
                          |  DbInsert  |                
                          |            |                
                          +------+-----+                
                                 |                      
                          +------+-----+                
                          |            |                
                +------&gt;  |   Merge    | &lt;------+       
                |         |            |        |       
                |         +------------+        |       
                |                               |       
           +----+-----+                  +------+------+
           |          |                  |             |
    +----&gt; |   Join   +--+               |   Filter    |
    |      |          |  |               |             |
    |      +----------+  |               +------+------+
    |                    |                      |       
+---+------+        +----+---+           +------+------+
|          |        |        |           |             |
| Postgres |        |  HDFS  |           |  Local file |
|          |        |        |           |             |
+----------+        +--------+           +-------------+

  A sample operator tree.
</pre>

A operator tree is driven by a LocalFragment, which is discussed in the next section. A LocalFagment maintains the execution environment of an Operator tree. 

### QueryPlan

MyriaX organizes its computation tasks by units of query plans. A query plan has a three layer hierarchical structure.

At the very top of a computation is the QueryPlan. A query plan has a globally identifiable long valued queryID, a set of properties that may control the execution of the query plan, for example how to react when a worker executing the query fails, and a mapping from workerID to sub queries. The maping from a workerID to a SubQueryPlan means the SubQueryPlan should be executed by the worker with id workerID.

A QueryPlan can be generated by many ways. The simplest way is to create the QueryPlan Java object completely by hand. A better way is to compose a Json execution plan. And even better is to use a higher end language such as MyriaL or Datalog.

When a QueryPlan is submitted, the system verifies the correctness of it and then dispatch the SubQueries to workers. A QueryPlan is considered running if any of the SubQueries is running. And currently if any of the SubQueries has errors during the execution, the whole QueryPlan will be killed. Note that here the errors are only limited to data processing errors. If any system error happens, for example, a worker machine gets down, the processing is up to the fault tolerance policies.


<pre>
+----------------------------------------------------------------+
|                                                                |
|  Query                                                         |
|                                                                |
|                                                                |
|                                                                |
| +-----------------------+         +--------------------------+ |
| |   Sub Query           |         |     Sub Query            | |
| |                       |         |                          | |
| | +------------------+  |         | +---------------------+  | |
| | |  LocalFragment 1 |  |         | |  LocalFragment 1    |  | |
| | +------------------+  |         | +---------------------+  | |
| | +------------------+  |         | +---------------------+  | |
| | |  LocalFragment 2 |  |         | |  LocalFragment 3    |  | |
| | +------------------+  |         | +---------------------+  | |
| +-+------------------+--+         +-+---------------------+--+ |
|                                                                |
|        Worker 1                           Worker 2             |
|                                                                |
+----------------------------------------------------------------+

</pre>

#### SubQuery

A SubQuery is the computation tasks that one worker is assigned in a QueryPlan. It contains a set of LocalFragments. The execution state of a SubQuery is similar to the execution state of a QueryPlan. When a SubQuery starts execution, all the LocalFragments start execution in the same time. A SubQuery is considered completed if all the LocalFragments are completed. And if any of the LocalFragments fails, the whole SubQuery will be marked as failure and gets killed.


#### LocalFragment
A LocalFragment is the basic execution unit in MyriaX. Each LocalFragment is a driver of a single Operator tree.

Very roughly, a LocalFragment runs a Operator tree in the following way (The actual implementation is much more complex because of all the concurrent state management):

```
while (executionCondition is satisified)
{
  if (operatorTree.fetchNextReady() is null and no new data arrived)
    break; // no data can be output currently
}
```

#### Execution mode and threading model
There are two execution modes for LocalFragments, i.e. Non-Blocking and Blocking. But the blocking mode is obsolete. It is not maintained long time ago. 

The differences between the two modes are mainly at the threading model. 

In the non-blocking mode, a query executor has a pool of a fixed number of threads for executing LocalFragments. The execution threads are similar to the *slots* in Hadoop. The LocalFragment is designed that when an executing LocalFragment finds out that no progress can be made, for example no more input data available, the LocalFragment should tell the execution system that it is willing to yield the execution resources to other LocalFragments. 

In the code block of the last section, the *yield* of a LocalFragment is implemented in changing the executionCondition to unsatisfied and in the break on no output.

The blocking mode has no such execution pool. Each time a LocalFragment is created, a new Java Thread is created to execute the operator tree. The executionConditions and the break will be ignored. The execution keeps going when any of the LocalFragements is not EOS and no errors occur.


####Execution condition

Each LocalFragment has a long state variable recording the current execution condition. Each bit of the long variable is a state indicator. Currently we have the following state bits:

  - STATE_INITIALIZED = (1 << 0) denotes if the owner LocalFragment is initialized. A LocalFragment is executable only if it is initialized.

  - STATE_STARTED = (1 << 1) records if the LocalFragment is allowed to start the execution. (TODO: not added by Shengliang, add more details by the actual author) .

  - STATE_OUTPUT_AVAILABLE = (1 << 2) denotes if all the output channels of this LocalFagment are writable. In the current implementation, if any of the output channels of a LocalFragment is not writable, the LocalFragment is not executable. But note that this is a soft constraint in that at the moment an output channel becomes unwritable, the LocalFragment may keep executing for a while.

  - STATE_INPUT_AVAILABLE = (1 << 3) denotes if currently there are any new input data that have not been checked by the operator tree.

  - STATE_KILLED = (1 << 4) denotes if the LocalFragment is already got killed.

  - STATE_EOS = (1 << 5).  As stated in the Operator section, each Operator has an EOS state variable. For an Operator tree, the EOS state of a whole true is the same as the EOS state of the root Operator. Once the EOS state of the root operator becomes true, the execution of the whole operator tree should be stopped. the STATE_EOS is set when the root operator reaches EOS.

  - STATE_EXECUTION_REQUESTED = (1 << 6). This bit is to prevent multiple parallel execution of the same LocalFragment. It is because there may be multiple threads trigger the execution of a LocalFragment, for example a data input thread may trigger the execution of a LocalFragment because a new TupleBatch just arrived, and a data output thread may also trigger the execution of a LocalFragment because all the ouptput channels become available.

  - STATE_FAIL = (1 << 7) is set when everthere's any error raised and does not get processed by the operator tree. The LocalFragement should stop execution in these cases. And it should notify the owner SubQuery.

  - STATE_INTERRUPTED = (1 << 8) is set when the execution thread gets interrupted. This usually happens when the system is shutting down.

  - STATE_IN_EXECUTION = (1 << 9) is set when the LocalFragment is in an execution. Together with the STATE_EXECUTION_REQUESTED, it also prevents from multiple parallel execution of the same LocalFragment.

To start executing a LocalFragment, the execution condition must be: 

> EXECUTION_PRE_START = STATE_INITIALIZED | STATE_OUTPUT_AVAILABLE | STATE_INPUT_AVAILABLE;

After execution starts, if the LocalFragment is ready to actually gets executed, the exeuction condition is:

> EXECUTION_READY = EXECUTION_PRE_START | STATE_STARTED;

When a LocalFragment executed a round (i.e. a call of fetchNextReady on the root Operator), it needs to check if currently another round of execution is needed. The execution condition is:

>  EXECUTION_READY | STATE_EXECUTION_REQUESTED | STATE_IN_EXECUTION;

### Scheduling
Currently there are no schedulers in Myria. Once a LocalFragment gets executed, it keeps executing until it yields. And also if there is a set of LocalFragments waiting for execution, and now a execution thread becomes free, it is not defined which waiting LocalFragment should get executed.

IPC
-------------

The IPC layer is the module that controls all the inter-process communications in MyriaX, including control message delivery and data message delivery. 

All the source codes of the IPC layer are in the edu.washington.escience.myria.parallel.ipc package. 
And all the functionalities of the IPC layer are provided through the IPCConnectionPool class.

The typical usage of the IPC layer is like the following code example:

```
    final IPCConnectionPool c =
        new IPCConnectionPool(myID, computingUnits, ..., payloadSerializer,
            messageProcessor, ...);
    c.start(...);
    ...
    c.sendShortMessage(receiver,message);
    ...
    StreamOutputChannel o = c.reserveLongTermConnection(receiver,dataStreamID);
    try{
      for (d : data)
        o.write(d);
    } finally {
      o.release();
      ...
    }
```

### The IPCEntities. 

The IPC layer is designed to support not only inter-process communications, but also intra-process communications. To provide this flexibility, the IPC layer abstracts the various senders and receivers using IPCEntity.

Each IPCEntity has an IPCID. It is currently an integer. Given a set of IPCEntities, the IPCID of each of them must be different in order for them to communicate with each other and must be non-negative integers. In currently MyriaX, IPCID of value 0 is reserved for the master. An IPCEntity can also specify negative IPCIDs as the destination of a communication connection. In this case it means connect to myself locally. 

Each IPCEntity also has a SocketInfo recording the address of the IPCEntity.  Currently, only IP4 addresses/host names together with port numbers are supported.

Each IPCEntity is mapped into a single instance of an IPCConnectionPool. If a Java process has several IPCConnectionPool instances, each of them is an IPCEntity. They are able to talk to each other as long as their IPCID are unique and the SocketInfo addresses are also unique.

### Services.

The IPC layer tries to hide all the complex and error prone concurrency/parallelism issues under a clean and easy to use interface. It provides two services for the users. 

  - **Standalone message delivery service**. This service can be accessed through the call of
  >  IPCConnectionPool.sendShortMessage(ipcID, message).
  
  This service is suitable for control message delivery. Given two calls of the sendShortMessage, there's no guarantee that the message sent by the first call is delivered and processed by the recipient before the message sent by the second call. 

  - **Stream data delivery service**. To use this service, firstly call 
  > streamOChannel = IPCConnectionPool.reserveLongTermConnection(ipcID, streamID, ...)
  
  and get a StreamOutputChannel instance. This will establish a data transfer channel (using TCP connections). And then data transfer can be achieved by calling
  > streamOChannel.write(message);  
 
 as many times as the number of messages there are waiting for getting transferred. Given two calls of the write method in the same *streamOChannel* instance, the message written by the first call is guaranteed to get delivered and processed before the second one.
 
 after all the messages are written, call
 >streamOChannel.release();
 
 to release the connection.


### IPC messages
The data unit that carries around by the IPC layer is IPCMessage.

#### IPC Header
Each IPCMessage has a header denoting the type of the IPCMessage.  Currently there are 6 headers: 
  *BOS*, *EOS*, *CONNECT*, *DISCONNECT*, *PING*, and *DATA*.
  
 **CONNECT(entityID)** is the first message sent by the IPC layer after a physical connection is created. This message tells the remote side of a physical connection the IPCID (i.e. entityID) of this side.

**DISCONNECT** is the last message sent by the IPC layer through a physical connection. It tells the remote side the physical conneciton has been abandoned by this side. If both the sides have abandoned the physical connection, the physical connection will be closed.
   
**BOS(streamID)** starts a data stream with a long typed streamID. This is the first message sent though a StreamOutputChannel instance.

**EOS** ends a data stream and is the last message sent through a StreamOutputChannel instance.

**PING** is a type of message that dedicated to the detection of the liveness of remote IPCEntities. When an IPCEntity writes a PING to another IPCEntity, the message should fail to deliver when the remote IPCEntity is dead.

**DATA** messages are user messages. It contains a binary array payload field that can hold anything.

#### IPC Payload

For a DATA IPCMessage, the payload of the message is user defined. The IPC layer does not know what the Java type of the payload is. It only sees the binary representation, i.e. the serialized byte array of the payload.

PayloadSerializer is the interface of implementing IPC message payload serialization/deserialization. When a user message is written by a user into the IPC layer, either through sendShortMessage or though the StreamOutputChannel.write(), the PayloadSerializer.serialize method will be invoked and the payload will be serialized into byte arrays. When a user message is received by the IPC layer, the PayloadSerializer.deserialize method will be invoked to create a structured java object from byte arrays.

In current implementation, Myria uses Google ProtoBuf for data serialization and de-serialization.

### Data Stream

In the stream data delivery service, The IPC layer has a notion of  data stream. However, different from the data stream in point-to-point data transfer protocols such as TCP, the data stream in the MyriaX IPC layer may have multiple input streams. And also the actual distribution of the input streams over processes or physical machines can be arbitrary.

<pre>
+---------------------------+                                      
| Worker 1                  |                                      
|                           |                                      
|     +-------------------+ |                                      
|     |   (wID:1, sID:2)  +-----------+                            
|     +-------------------+ |         |                            
|                           |         |                            
|     +-------------------+ |         |          +----------------+
|     |   (wID:1, sID:3)  +-----------+          |                |
|     +-------------------+ |         |          |  Data Stream:  |
+-----+-------------------+-+         |          |                |
                                      +--------> |  | wID | sID|  |
                                      |          |     1     2    |
+-----+-------------------+-+         |          |     1     3    |
|     +-------------------+ |         |          |     2     2    |
|     |   (wID:2, sID:2)  +-----------+          +----------------+
|     +-------------------+ |                                      
|                           |                                      
| Worker 2                  |                                      
+---------------------------+                                      
</pre>

For example, the above diagram illustrates a data stream that has three input streams. The first two input streams are from worker 1 and the third input stream are from worker 2.

For the input streams, there can be many semantics. For example, set, bag or ordered. Currently, only bag-semantic data streams are implemented in MyriaX.

#### StreamInputBuffers

MyriaX uses an input buffer mechanism as a way of decoupling the IO module and the query execution module. 

<pre>
Input stream 1  +--------> +---------------+
                           |               |
                           |     Stream    |
Input stream 2  +--------> |  Input Buffer | -------> QueryExecution
                           |               |
                           |               |
Input stream 3  +--------> +---------------+
</pre>

A stream input buffer is :

 -  A trunk of memory where the IO threads put data in and the query executor thread(s) pull data out.
 -  The physical representation of a logical data stream. When an input buffer is created, it receives a set of input data stream IDs in the format of a tuple (workerID, streamID). When an input buffer starts, it is ready to receive data. The input buffer is considered open when there is any logical input stream that has not EOS. When all the logical input streams are EOS, the input buffer is EOS. At that point, no data can be put into the buffer. And also, data that is not from any of the logical input streams will be dropped.

Currently only bag-semantic input buffers are implemented in MyriaX.

#### Threading model

Data Inputs:
The input buffers are filled by IO workers. In current implementation, the IO workers are the worker threads of 
. There's no restriction on the threading model of the input streams. Currently, the input streams and the IO threads are n:1 mapping, i.e. data from one input stream will always be put into an input buffer by the same thread, but an IO thread may put data from multiple input streams. 

Data Outputs:
The threading model of pulling data out of an input buffer is upon implementations of input buffers. Current major implementation, i.e. the FlowControlInputBuffer, requires that only a single thread pulls data.

### Connection pooling.
MyriaX relies on Java NIO for actual connection creation and data transferring. More specifically we use [Netty](http://netty.io).

MyriaX maintains a one-to-one mapping between stream data connections or standalone message data connections and Netty connections. 

For remote Netty connections, the IPC layer will not immediately release them at the time they are released by the user either in stream data transferring or standalone message transferring . The connections are pooled instead.  The pooling works according to the following policy:
 
  - If the number of currently alive connections to a destination IPCEntity is less than MIN_POOL_SIZE, each time a call to sendShortMessage or reserveLongTermConnection (we'll refer these method calls as new connection request for convenience) will create a new connection to the destination. 
  
  - If the number of currently alive connections to a destination IPCEntity >= MIN_POOL_SIZE, a new connection request checks if currently there is any existing connection that nobody is using it. If there exists such a connection, this connection will be reused, otherwise, create a new connection.

  - When a user releases a connection, if currently the size of the connection pool >MAX_POOL_SIZE, the connection will be released immediately.

  - When a user releases a connection, if currently the size of the connection pool <=MAX_POOL_SIZE but >=MIN_POOL_SIZE, the connection will not be released immediately, and a timeout timestamp mark will be placed on the connection. If within the timeout, the connection is not get reused, the connection will be released.

  - When a user releases a connection, if currently the size of the connection pool < MIN_POOL_SIZE, the connection will not be released and also no timeout releasing.
 
### Flow control.

Netty abstracts all the data transferring operations through a Channel interface. For each Channel, there is a bit controlling whether currently the channel should read data from the underlying system network stack.  The bit can be set by calling  
>Channel.setReadable(readable).

 If data reading is paused, the system network layer at the recipient side notifies the sender side to stop sending data once the system receive buffer is full. This mechanism of flow control is called network back pressure.

MyriaX adopts a push based data transferring model. The sender keeps sending data until the recipient is not able to process them quickly enough. And the flow control in MyriaX is exactly the back pressure mechanism.

Currently the flow controlling is implemented in input buffers, more specifically, the FlowControlInputBuffer class. The mechanism is as the following:

  - The flow control of a FlowControlInputBuffer is controlled by two parameters: *soft capacity* and *recover trigger*. Both are non-negative integers and that *soft capacity* > *recover trigger*.
  - Let the size of current input buffer is *x*, i.e. currently there are *x* data messages stored in the input buffer.
  - When a new data message comes, it does the following:
  ```
   if x+1 >= capacity and the last event triggered is not buffer full
      trigger buffer full event
      // the buffer full listeners are executed,
      // including stop reading from all the underlying Netty channels
    
   ```
  - When a data message gets drawn, it does the following:
  ```
   if x+1 <= recover trigger and the last event triggered is buffer full
      trigger buffer recover event
      // the buffer recover listeners are executed,
      // including resume reading from all the underlying Netty channels
    
   ```
  - When a data message gets drawn and results an empty input buffer, the buffer empty event is triggered. Currently, it resumes reading of the channels too, although is not necessary actually.
  