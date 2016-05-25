---
layout: default
title: Big Data Query Languages
date: 2015-10-12
excerpt: "Language interfaces for complex analytics at scale"
id: "bigdatalanguages"
---

## {{ page.title }}

A large number of data exploration and analytics queries are iterative. We study advanced optimization techniques for iterative programs on massively parallel systems. In prior work we have explored the fundamental systems architecture needed for iterative data processing, and have investigated some simple optimization techniques. Our research now is developing new, advanced optimizations: using materialized views and dynamic re-optimization.

Myria accepts queries written in SQL, Datalog, or a new Pig Latin-like language we call *MyriaL*. Based on our experience with [SQLShare](https://uwescience.github.io/sqlshare/), we believe that science users can write data analysis tasks in SQL. We expect Datalog’s declarative style to have similar appeal, especially for recursive queries. Myria’s Datalog compiler has support for stratified negation and a v
ariety of simple aggregates. Myria uses semi-naive evaluation to efficiently compute recursive results, using asynchronous computation wh
en possible.

MyriaL is a hybrid imperative/declarative language, similar to [Pig Latin](http://infolab.stanford.edu/~usriv/papers/pig-latin.pdf) exten
ded with iteration. We developed MyriaL in a way that lets users express efficient execution strategies in a declarative way which the qu
ery execution engine optimize easier than Datalog. MyriaL also supports functions and complex operations for importing, transforming and 
operating on data.

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

