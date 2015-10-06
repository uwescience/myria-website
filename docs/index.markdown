---
layout: default
title: Start Here 
group: "docs"
weight: 0
---

# Getting Started with Myria
This page cover the following topics:

* How to use the Myria demonstration and production services hosted by UW, from either the web front-end, the Python API or an IPython notebook.
* How to setup your own Myria service, either on a local laptop, cluster or Amazon EC2 instance. 

Developers, please see our [Myria Developer](developer.html) page.

Questions? See our [FAQ](faq.html). 

## Learning about the Myria stack

For a short overview of Myria as a cloud service and a big data management system, see our demo [paper](http://myria.cs.washington.edu/publications/Halperin_Myria_demo_SIGMOD_2014.pdf).

Check out the overview slides from the demonstration we gave in the eScience Community Seminar in May 2015:  [overview slides](./myria-overview-may2015.pdf).

The [Myria Middleware doc page](myriaMiddleware.html) has an excellent overview of how Myria's three components are designed and fit together: MyriaX, MyriaMiddleware and MyriaWeb.

## Using Myria services hosted by UW

We are hosting two Myria services:

- Demonstration service: <http://demo.myria.cs.washington.edu>
The demo service runs on Amazon EC2 and is a small version of Myria running on only four instances.
The demo service is there to make it easy to get a sense of what Myria is about but don't use it to do any actual work
nor test anything at scale.

- Production service: Please email <myria-users@cs.washington.edu> to request access.
The production service is a 72 instance deployment and it runs in the private cluster of the University of Washington
Database Group. 

See the following section for how to spin up a myria instance on your local computer, cluster or Amazon EC2 instance.


### Using the Myria demonstration service through the browser


Open your browser, preferably Chrome, and point it at: [http://demo.myria.cs.washington.edu](http://demo.myria.cs.washington.edu)

You will see a window that will enable you to write MyriaL or SQL queries and execute them with Myria. 

Here is a quick tour of the interface:

- At the top of the screen, you should see three tabs: "Editor", "Queries", and "Datasets".
Click on the "Datasets" tab. Here, you can see the list of all the datasets currently ingested
and available in the service. You can click on the name of a dataset to see its metadata
including the schema.  Click on "JSON", "CSV", or "TSV" to download the dataset in the
specified format.

- Now click on the "Queries" tab. This is where you can see all the queries that yourself
and others have been running. Observe the keyword search window. Type, for example, 
the word "Books" to see all queries executed on the "Brandon:Demo:Books" relation
in Myria.

- Finally, click on the "Editor" tab. This is where you can write and execute queries.
You can start from one of the examples on the right. Click on the example and the
query will appear in the editor window. Queries can be written in SQL or MyriaL. We
recommend MyriaL because, in that mode, you can inter-twine SQL and MyriaL in your
script.

Try the following query, which scans the Brandon:Demo:Books relation,
filters some elements, and computes an aggregate that it stores in a relation
called "public:adhoc:AggregatedBooks":


    T1 = scan(Brandon:Demo:Books);

    Filtered = SELECT * FROM T1 WHERE pages > 10;

    AggregatedBooks = SELECT count(*) FROM Filtered;

    Store(AggregatedBooks, AggregatedBooks);


First click on "Parse". This will show you the query plan that Myria will
execute. Then click on "Execute Query". This will execute the query and
produce a link to the output. 

Now select  the "Profile Query" option below the query window and
re-execute the query with the option ON.  Below the result, you will
see the "Profiling results". Click on it. It wil show you profiling information
about the way the query executed. Explore the output of the profiler.

Now let's execute a query that reads new data from S3. This query
reads the data and stores it in relation "public:adhoc:smallTable". The
extra argument in the Store statement means to hash-partition the
data on the first attribute and store it hash-partitioned across all
four worker instances. It is informative to first see the query plane (click on "Parse")
and then to execute the query.

    smallTable = load("https://s3-us-west-2.amazonaws.com/uwdb/sampleData/smallTable", csv(schema(column0:int, column1:int), skip=0));

    Store(smallTable, smallTable, [$0]);


Now, we can execute queries on the newly ingested data:

    t = scan(public:adhoc:smallTable);

    smallTableAggregated = select count(*) from t;

    Store(smallTableAggregated, smallTableAggregated);

  

### Using the Myria Service from Python

For more complex analysis, it may be useful to interact with Myria using Python.

#### Part 1: Upload/Download Data
To upload data, this can be done through the [Python API](myriapython.html), under the "Using Python with the Myria Service" section.

#### Part 2: Running Queries on the Service

To start building queries once the data is uploaded, you can either write your queries directly through our [Myria Web Frontend](https://demo.myria.cs.washington.edu/editor) as demonstrated above, [Python](myriapython.html), or [IPython Notebook](https://github.com/uwescience/myria-python/blob/master/ipnb%20examples/myria%20examples.ipynb). To learn more about the Myria query language, check out the [MyriaQL](myriaql.html) page.


## Using your own Myria stack

For many users at the University of Washington, you do not need to download
the source code or start your own stack. 
You can instead use the Myria production service (see above for requesting access).

### Getting source code for the whole Myria stack

Unless you are only interested in a specific component, the best place to 
start is with the [Myria Stack Repository](https://github.com/uwescience/myria-stack).

The Myria Stack repository is the umbrella repository that contains all the
components of the Myria stack as modules. To get all the source code, you
need to run the following commands:

    git clone https://github.com/uwescience/myria-stack.git

    cd myria-stack

    git submodule init

    git submodule update --recursive

Now you should see the Myria source code on your machine.



### Running the MyriaX execution engine part of the Myria stack

#### Part 1: Setting up the Myria service
MyriaX is designed to run in a shared-nothing cluster. It consists of
a coordinator process and a set of worker processes. The coordinator receives query
plans in JSON through a REST api and gets the workers to
execute these query plans.

There are three ways to run MyriaX:

- Run MyriaX locally on a laptop or desktop. This is the easiest
way to get to experiment with MyriaX. This setup is not designed
to deliver high-performance. It should be thought of as an experimental
or debug mode. 

- Run MyriaX in an existing cluster.

The instructions to run MyriaX either locally or in an existing cluster are here:  [Running the MyriaX engine](myriaX.html). 

- Run MyriaX in a public cloud.

The instructions to deploy MyriaX on Amazon EC2 are here: [Running Myria on Amazon EC2](myria-ec2.html).

#### Part 2: Running queries on the service
After you setup the engine, you can upload data and run queries through the [Python API](myriapython.html) under the "Using Python with your own Myria Deployment" section. An alternative way to run queries is via the [Myria Web](myriaweb.html) interface.

### Myria Use Cases
In addition to the [Python tutorial doc](myriapython.html) referenced above,
we are developing example real-world use cases here: 

* [N-body](usecase-astronomy.html)

