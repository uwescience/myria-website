---
layout: default
title: Projects & Publications
group: "navigation"
id: "projects"
---

# Projects, Publications, and Software

Myria is a new stack for big data management and analytics:

* Myria is a new big data management and analytics system
* It is available open source [Myria stack on Github] (https://github.com/uwescience/myria-stack)
* It runs in shared-nothing clusters (Amazon EC2)
* Myria is also a service. Check our [demo service] (http://demo.myria.cs.washington.edu).
  If you are at UW and would like to try our production service, send an email to myria-users@cs.washington.edu
 
Myria is developed by the UW database group and eScience Institute.

On this page, we describe the specific research contributions
that we are making through the Myria project.


## Big Data Management Theory

We are studying the foundations of efficient Big Data management, which leads to new fundamental results regarding the complexity of various ad hoc data transformations in modern massive-scale parallel systems.

Our model of computation is an extension of the Massively Parallel (MPC) model, where computation is performed by p severs that alternate between local computation and re-shuffling steps, and each server is limited to O(n/p) space, where n is the size of the data. We study the time/space complexity of data transformations and extensions to cope with failures.

* [Skew in Parallel Query Processing](http://homes.cs.washington.edu/~pkoutris/papers/skew.pdf). Paul Beame, Paraschos Koutris, Dan Suciu. *PODS 2014*.
* [Communication steps for parallel query processing](http://homes.cs.washington.edu/~pkoutris/papers/parallel_steps.pdf). Paul Beame, Paraschos Koutris, Dan Suciu. *PODS 2013*.
* [Parallel Evaluation of Conjunctive Queries](http://homes.cs.washington.edu/~pkoutris/papers/pods11.pdf). Paraschos Koutris, Dan Suciu. *PODS 2011*.

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

<iframe width="500" height="281" src="//www.youtube.com/embed/v1ZNf1EgG4o" frameborder="0" allowfullscreen></iframe>

## Systems-challenges of Efficient Big Data Management

We are studying a variety of challenges related to building systems for efficient Big Data management. A large fraction of this work is done in the context of the [Nuage project](http://nuage.cs.washington.edu). We are also tackling challenges related to the usability of Big Data systems in the [CQMS project](http://cqms.cs.washington.edu/).

In the specific context of the Myria project, we started to focus on challenges associated with efficient iterative processing. In particular, failures and load imbalances are increasingly common as the size of data processing tasks grows, and exacerbated in iterative programs. In prior work, we have extensively studied both problems for non-iterative computations. For iterative programs, we propose a radically new, extremely lightweight approach, which we call FT/Skew Skip Mechanism: when a server fails, we simply allow the other servers to continue the iteration. The failed computation either re-joins eventually, after recovery; or is abandoned altogether, if the resulting accuracy is still acceptable. We treat skew as a form of failure: servers that are too slow to respond are assumed to have failed. We are studying this approach and other light-weight fault-tolerance and load balance techniques for iterative computations.

## Query profiling and visualization

We developed a tool to interactively explore query execution. This allows users to profile and debug queries.

* [Perfopticon: Visual Query Analysis for Distributed Databases](https://idl.cs.washington.edu/files/2015-Perfopticon-EuroVis.pdf). Dominik Moritz, Daniel Halperin, Bill Howe, Jeffrey Heer *Computer Graphics Forum (Proc. EuroVis)* 2015.

<iframe src="https://player.vimeo.com/video/127110709" width="500" height="281" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>


## Big Data Management as a Cloud Service

An important focus of Myria is not just on managing Big Data but on doing so using a Cloud service. We are thus studying various aspects of this problem. Specifically, we are studying a new type of SLA that will enable Cloud providers to offer Big Data Management and Analytics as a service with a more user-friendly and performance-friendly service-level agreement (SLA).

Today's pricing models and SLAs are described at the level of compute resources (instance-hours or gigabytes processed). They are also different from one service to the next. Both conditions make it difficult for users to select a service, pick a configuration, and predict the actual analysis cost. To address this challenge, we propose a new abstraction, called a Personalized Service Level Agreement (PSLA), where users are presented with what they can do with their data in terms of query capabilities, guaranteed query performance and fixed hourly prices.

* [A Vision for Personalized Service Level Agreements in the Cloud](publications/Ortiz_PSLA_2013.pdf). Jennifer Ortiz, Victor T. Almeida, Magda Balazinska. *SIGMOD Workshop on Data Analytics in the Cloud (DanaC) 2013*.

* [Changing the Face of Database Cloud Services with Personalized Service Level Agreements](publications/Ortiz_PSLA_CIDR_2015.pdf). Jennifer Ortiz, Victor T. Almeida, Magda Balazinska. *CIDR 2015*.

<iframe width="500" height="281" src="//www.youtube.com/embed/f1dJfQXyT7A" frameborder="0" allowfullscreen></iframe>


## Myria System and Service

All the above ideas are brought together in a new Big Data management system called Myria that we are currently building as a cloud service.

We presented a demo of Myria at SIGMOD 2014:

*D. Halperin, V. T. Almeida, L. L. Choo, S. Chu, P. Koutris, D. Moritz, J. Ortiz, V. Ruamviboonsuk, J. Wang, A. Whitaker, S. Xu, M. Balazinska, B. Howe, and D. Suciu.*
[Demonstration of the Myria Big Data Management Service](publications/Halperin_Myria_demo_SIGMOD_2014.pdf), SIGMOD 2014.

## MyMergerTree Service

MyMergerTree is a vertical service built on top of Myria to facilitate the study of the formation of galaxies through the visualization of galactic merger trees. By utilizing Myria's REST API to compute these trees, we can provide astronomers with interactive visualizations to dramatically improve the speed and efficiency of their data analysis. Below are the MyMergerTree demo, part of the Myria demo at SIGMOD 2014, and links to the demo's poster and to the MyMergerTree paper presented at the DanaC Workshop at SIGMOD 2014.

* [MyMergerTree Service: Creating Galactic Merger Trees using Myria](http://db.cs.washington.edu/posters/MyMergerTree.pdf). Presented by Laurel Orr, Sarah Loebman, Jennifer Ortiz, and Daniel Halperin. Demo poster at *SIGMOD 2014* (in the context of the [group Myria demo]({{site.baseurl}}/publications/Halperin_Myria_demo_SIGMOD_2014.pdf)).
* [Big-Data Management Use-Case: A Cloud Service for Creating and Analyzing Galactic Merger Trees]({{site.baseurl}}/publications/MyMergerTree_DanaC_2014.pdf). Sarah Loebman, Jennifer Ortiz, Lee Lee Choo, Laurel Orr, Lauren Anderson, Daniel Halperin, Magdalena Balazinska, Thomas Quinn, and Fabio Governato. *SIGMOD Workshop on Data Analytics in the Cloud (DanaC) 2014*.

<iframe width="500" height="281" src="//www.youtube.com/embed/RMEKp_BUcfQ" frameborder="0" allowfullscreen></iframe>

<iframe width="500" height="281" src="//www.youtube.com/embed/Xe4O207izi0" frameborder="0" allowfullscreen></iframe>
