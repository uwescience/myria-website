---
layout: default
title: MyriaL
weight: 3
---

# MyriaL

MyriaL is an imperative-yet-declarative high-level data flow language based on the relational algebra that includes support for iteration, user-defined functions, multiple expression languages, and familiar language constructs such as set comprehensions.  The language is the flagship programming interface for the Myria system, and can be compiled to a number of backends.

MyriaL was designed by the Database group at the University of Washington, led by Andrew Whitaker, now at Amazon.

The language began as a ``whiteboard language'' for reasoning about the semantics of Datalog programs.  At the time, we anticipated Datalog becoming our premier programming interface.  But the fact that we were using an imperative style language to reason about Datalog made us realize we should just implement the imperative language directly.

MyriaL is imperative: Each program is a sequence of assignment statements.  However, it is also declarative, in two ways: First, the optimizer is free to reorder blocks of code and apply other transformations as needed prior to execution, meaning that the programmer need not write the ``perfect'' program for decent performance.  Second, the right-hand-side of each assignment statement may itself be a declarative expression; programs may mix and match SQL and set comprehensions, for example. We find this combination of features to strike a useful balance between programmer control and programmer convenience.

##Reading Data and Storing in Myria
 
###Load and Store
Myria can read and store a CSV file from S3 via the load command:

**Example #1: Loading and Storing "TwitterK" data

    T1 =LOAD("https://s3-us-west-2.amazonaws.com/uwdb/sampleData/TwitterK.csv", csv(schema(a:int, b:int),skip=0));
    STORE(T1, TwitterK, [a, b]);

**Example #2: Loading and Storing "Points" data

    T2 = LOAD("https://s3-us-west-2.amazonaws.com/uwdb/sampleData/sampleCrossmatch/points.txt",
              csv(schema(id:int,
                         x:float,
                         y:float,
                         z:float), skip=0));
              STORE(T2, points, [x,y,z]);
    
*MyriaL needs explicit partition attribute specified for a relation uploaded via load operator, once this issue is fixed, partition attribute will not need to be specifed. For now, storing requires the following: STORE(sourceRelation, DestinationRelation, optional[PartitionAttribute])*

##Transforming Data
###Comprehensions
\*To Do*

###SQL
--Create an empty relation with a particular schema

    newRelation = empty(x:float, y:float, z:float);
    
###Scan a Relation

    T1 = SCAN(relationName);
     T1 = SCAN(TwitterK);
    
###Aggregation

    T1 = SCAN(TwitterK); 
     Groups = [FROM T1 EMIT COUNT(a) AS cnt, T1.a AS id];
     STORE(Groups, OUTPUT, [$1]);

###Join 

    T1 = SCAN(TwitterK);
     T2 = SCAN(TwitterK);
     Joined = [FROM T1, T2
              WHERE T1.$1 = T2.$0
              EMIT T1.$0 AS src, T1.$1 AS link, T2.$1 AS dst];
          
    STORE(Joined, TwoHopsInTwitter);

###Union
-- '+' is a union operator in MyriaL

    T2 =  SCAN(TwitterK);
     T3 = SCAN(TwitterK);
     result = T2+T3;
     STORE(result, union_result);

##Expressions
###Arithmetic

    T3 = [FROM SCAN(TwitterK) as t EMIT sin(a)/4 + b AS x];
    STORE(T3, ArithmeticExample);

    --Unicode math operators ≤, ≥, ≠

    T4 = [FROM SCAN(TwitterK) as t WHERE $0 ≤ $1 and $0 ≠ $1 and $1 ≥ $0 EMIT *];
    STORE(T4,  ArithmeticExample2);

###Constants
--A constant as a singleton relation

    N = [2];

###Literals
\*To Do*
##Loops

    DO
      stats = [FROM scan(points) as points EMIT avg(x) AS mean, stdev(x) AS std];
      NewBad = [FROM scan(points) as points, stats WHERE abs(x - mean) > 10 * std EMIT points.*];
      points = diff(scan(points), NewBad);
      continue = [FROM NewBad EMIT count(NewBad.x) > 0];
    WHILE continue;



##Functions
__User-defined function to calculate modulo operation__

    def mod(x, n): x - int(x/n)*n;
    T1 = [from scan(TwitterK) as t emit mod($0, $1)];
    STORE(T1, udf_result);

 
 __User-defined aggregate function__
 
    apply RunningMean(value) {
      -- initialize the custom state, set cnt = 0 and summ = 0
      [0 as cnt, 0 as running_sum];
      -- for each record, add one one to the count (cnt) and add the record value to the sum (summ)
      [cnt + 1, running_sum + value];
      -- on each record, produce the running sum divided by the running count
      running_sum / cnt;
    };
    T1 = [from scan(TwitterK) as t emit RunningMean($0)];
    STORE(T1, twitter_running_mean);

##Stateful Apply
-- Applying a counter for each partition of the TwitterK relation

    APPLY counter() {
      [0 AS c];
      [c + 1];
      c;
    };
    T1 = SCAN(TwitterK);
    T2 = [FROM T1 EMIT $0, counter()];
    STORE (T2, K);
    
##Comments
The Myria Catalog is case sensitive, so please make sure to Scan the correct relation name.

## Advanced Examples

* [PageRank in MyriaL](https://github.com/uwescience/raco/blob/master/examples/pagerank.myl)
* [K-Means in MyriaL](https://github.com/uwescience/raco/blob/master/examples/kmeans.myl)
* [Sigma Clipping in MyriaL](https://github.com/uwescience/raco/blob/master/examples/sigma-clipping.myl)
* [Connected Components in MyriaL](https://github.com/uwescience/raco/blob/master/examples/connected_components.myl)
* [Coordinate Matching in MyriaL](https://github.com/uwescience/raco/blob/master/examples/crossmatch_2d.myl)
