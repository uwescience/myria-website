---
layout: default
title: MyriaL Language Reference
group: "docs"
weight: 3
section: 3
---

# MyriaL

MyriaL is an imperative-yet-declarative high-level data flow language based on the relational algebra that includes support for SQL syntax, iteration, user-defined functions, and familiar language constructs such as set comprehensions.  The language is the flagship programming interface for the Myria big data management system, and can it also be compiled to a number of other back ends.

The language began as a ``whiteboard language'' for reasoning about the semantics of Datalog programs.  At the time, we anticipated Datalog becoming our premier programming interface.  But the fact that we were using an imperative style language to reason about Datalog made us realize we should just implement the imperative language directly.

MyriaL is imperative: Each program is a sequence of assignment statements.  However, it is also declarative, in two ways: First, the optimizer is free to reorder blocks of code and apply other transformations as needed prior to execution, meaning that the programmer need not write the ``perfect'' program for decent performance.  Second, the right-hand-side of each assignment statement may itself be a declarative expression: either a SQL query or a set comprehension. We find this combination of features to strike a useful balance between programmer control and programmer convenience.

MyriaL was designed by the Database group at the University of Washington, led by Andrew Whitaker, now at Amazon.

##Reading Data and Storing in Myria

###Ingesting data
Myria can read and store a CSV file from S3 via the load command:

* Example #1: Loading and Storing "TwitterK" data

```sql
    T = LOAD("https://s3-us-west-2.amazonaws.com/uwdb/sampleData/TwitterK.csv", csv(schema(a:int, b:int),skip=0));
    STORE(T, TwitterK, [a, b]);
```

The `skip` option takes the number of lines at the beginning of the csv file to skip over.
Here, Myria will create a relation `T1` with the contents of `TwitterK.csv` and store it in a table called `TwitterK`. The third argument, `[a, b]`, is a list of attributes to partition the rows by.

* Example #2: Loading and Storing "Points" data

```sql
    T = LOAD("https://s3-us-west-2.amazonaws.com/uwdb/sampleData/sampleCrossmatch/points.txt",
              csv(schema(id:int,
                         x:float,
                         y:float,
                         z:float), skip=0));
              STORE(T, points, [x,y,z]);
```

*The partition argument to STORE is actually optional. However, MyriaL needs explicit partition attribute specified for a relation created via LOAD.*

###Reading existing relations

Once a relation is stored, Myria can access use it in later queries with `SCAN`. This example simply repartitions the `TwitterK` relation by just attribute `a`.

```sql
    T = SCAN(TwitterK);
    STORE(T, TwitterK_part_a, [a]);
```

###Create an empty relation

```sql
--Create an empty relation with a particular schema
r = empty(x:int, y:float, z:string);
STORE(r, myrelation);
```


##Transforming Data

Now for some real queries! MyriaL has two styles of syntax: SQL and comprehensions. If you've used [list comprehensions in python](https://docs.python.org/2/tutorial/datastructures.html#list-comprehensions) then MyriaL's comprehensions will look familiar. Use the style you prefer or mix and match.



###Select, from, where

Let's find the twitter relationships where the follower and followee are the same user.

```sql
T = scan(TwitterK);
-- SQL style syntax
s = select * from T where a = b;
store(s, selfloops);
```

```sql
T = scan(TwitterK);
-- comprehension syntax
s = [from T where a = b emit *];
store(s, selfloops);
```

###Join

Joins let us match two relations on 1 or more attributes. This query finds all the friend-of-friend relationships in TwitterK.

```sql
    T1 = SCAN(TwitterK);
     T2 = SCAN(TwitterK);
     Joined = select T1.a, T1.b, T2.b
                  from T1, T2
                  where T1.b = T2.a;
    STORE(Joined, TwoHopsInTwitter);
```

```sql
    T1 = SCAN(TwitterK);
     T2 = SCAN(TwitterK);
     Joined = [FROM T1, T2
              WHERE T1.b = T2.a
              EMIT T1.a AS src, T1.b AS link, T2.b AS dst];

    STORE(Joined, TwoHopsInTwitter);
```

###Aggregation

Aggregation lets us combine results from multiple tuples. This query counts the number of friends for user 821.

```sql
T = scan(TwitterK);
cnt = select COUNT(*) from T where a=821;
store(cnt, user821);
```

```sql
T1 = scan(TwitterK);
cnt = [from T1 where a=821 emit COUNT(*) as x];
store(cnt, user821);
```

We can also group by attributes and aggregate others. This query counts the number of friends for *each* user.

```sql
T = scan(TwitterK);
cnt = select a, COUNT(*) from T;
store(cnt, degrees);
```

```sql
T1 = scan(TwitterK);
cnt = [from T1 emit a, COUNT(*) as x];
store(cnt, degrees);
```

Notice that MyriaL's syntax differs from SQL for group by. MyriaL groups by all attributes in the select clause without using a group by clause. For clarity, the equivalent SQL query is:

```sql
select a, COUNT(*) from T group by a;
```


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
* [Pairwise Distance Computation](https://github.com/uwescience/raco/blob/master/examples/pairwise_distances.myl)
