---
layout: default
title: Projects & Publications
group: "navigation"
rank: 2
---

# Projects, Publications, and Software

We are tackling several inter-related challenges:


## Big Data Management Theory

We are studying the theory of efficient Big Data management, which leads to new fundamental results regarding the complexity of various ad hoc data transformations in modern massive-scale systems.

Our model of computation is an extension of our recent Massively Parallel (MP) model, where computation is performed by P severs that alternate between computation and re-shuffling steps, and each server is limited to O(n/P) space, where n is the size of the data. We study the time/space complexity of data transformations and extensions to cope with failures.


## Big Data Query languages

A large number of data exploration and analytics queries are iterative. We study advanced optimization techniques for iterative programs on massively parallel systems. In prior work we have explored the fundamental systems architecture needed for iterative data processing, and have investigated some simple optimization techniques. Our research now is developing new, advanced optimizations: using materialized views and dynamic re-optimization.

Myria accepts queries written in SQL, Datalog, or a new Pig Latin-like language we call *MyriaL*. Based on our experience with [SQLShare](https://sqlshare.escience.washington.edu/), we believe that science users can write data analysis tasks in SQL. We expect Datalog’s declarative style to have similar appeal, especially for recursive queries. Myria’s Datalog compiler has support for stratified negation and a variety of simple aggregates. Myria uses semi-naive evaluation to efficiently compute recursive results, using asynchronous computation when possible.

MyriaL is a hybrid imperative/declarative language, similar to [Pig Latin](http://infolab.stanford.edu/~usriv/papers/pig-latin.pdf) extended with iteration. We developed MyriaL in a way that lets users express efficient execution strategies in a declarative way which the query execution engine optimize easier than Datalog. MyriaL also supports functions and complex operations for importing, transforming and operating on data.

Graph reachability can be expressed in MyriaL as:

```python
Edge = SCAN(user@uw.edu:edges_table);
Reachable = [1]; Delta = Reachable;
DO
  NewNodes = [FROM Delta, Edge
              WHERE Delta.addr == Edge.src
              EMIT addr=Edge.dst];
  Delta = DIFF(DISTINCT(NewNodes), Reachable);
  Reachable = UNIONALL(Delta, Reachable);
WHILE [*COUNTALL(Delta) > 0];
```


## Systems-challenges of Efficient Big Data Management

We are studying a variety of challenges related to building systems for efficient Big Data management. A large fraction of this work is done in the context of the [Nuage project](http://nuage.cs.washington.edu). We are also tackling challenges related to the usability of Big Data systems in the [CQMS project](http://cqms.cs.washington.edu/).

In the specific context of the Myria project, we started to focus on challenges associated with efficient iterative processing. In particular, failures and load imbalances are increasingly common as the size of data processing tasks grows, and exacerbated in iterative programs. In prior work, we have extensively studied both problems for non-iterative computations. For iterative programs, we propose a radically new, extremely lightweight approach, which we call FT/Skew Skip Mechanism: when a server fails, we simply allow the other servers to continue the iteration. The failed computation either re-joins eventually, after recovery; or is abandoned altogether, if the resulting accuracy is still acceptable. We treat skew as a form of failure: servers that are too slow to respond are assumed to have failed. We are studying this approach and other light-weight fault-tolerance and load balance techniques for iterative computations.


## Big Data Management as a Cloud Service

An important focus of Myria is not just on managing Big Data but on doing so using a cloud service. We are thus studying various aspects of this problem. Specifically, we are studying a new type of SLA that will enable Cloud providers to offer Big Data Management and Analytics as a service with a more user-friendly and performance-friendly service-level agreement (SLA).

Today's pricing models and SLAs are described at the level of compute resources (instance-hours or gigabytes processed). They are also different from one service to the next. Both conditions make it difficult for users to select a service, pick a configuration, and predict the actual analysis cost. To address this challenge, we propose a new abstraction, called a Personalized Service Level Agreement (PSLA), where users are presented with what they can do with their data in terms of query capabilities, guaranteed query performance and fixed hourly prices.

*Ortiz, J., Almeida, V. T., Balazinska, M.,[A Vision for Personalized Service Level Agreements in the Cloud](publications/Ortiz_PSLA_2013.pdf), Workshop on Data Analytics in the Cloud with SIGMOD 2013, June 2013*


## MyriaDB System and Service

All the above ideas are brought together in a new Big Data management system called MyriaDB that we are currently building as a cloud service.