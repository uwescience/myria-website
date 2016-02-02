---
layout: default
title: Big Data Systems Research
date: 2015-07-12
excerpt: "Systems challenges for big data processing"
id: "bigdatasystems"
---

## {{ page.title }}

In the specific context of the Myria project, we started to focus on challenges associated with efficient iterative processing and complex analytic queries. In particular, failures and load imbalances are increasingly common as the size of data processing tasks grows, and exacerbated in iterative programs. In prior work, we have extensively studied both problems for non-iterative computations. For iterative programs, we propose a radically new, extremely lightweight approach, which we call FT/Skew Skip Mechanism: when a server fails, we simply allow the other servers to continue the iteration. The failed computation either re-joins eventually, after recovery; or is abandoned altogether, if the resulting accuracy is still acceptable. We treat skew as a form of failure: servers that are too slow to respond are assumed to have failed. We are studying this approach and other light-weight fault-tolerance and load balance techniques for iterative computations.

* [Asynchronous and Fault-Tolerant Recursive Datalog Evaluation in Shared-Nothing Engines]
(https://homes.cs.washington.edu/~jwang/papers/p2317-wang.pdf).
Jingjing Wang, Magdalena Balazinska, and Daniel Halperin *VLDB 2015*
We study computing complex join queries efficiently, including queries with cyclic joins, on a massively parallel architecture. We pushed two independent lines of theoretical work for multi-join query evaluation into practice: a communication-optimal algorithm for distributed evaluation, and a worst-case optimal algorithm for sequential evaluation. As a result, our system is able to efficiently handle complex queries from novel applications such as social network analytics and knowledge discovery on knowledge base up to order of magnitute faster compared with traditional systems.

* [From Theory to Practice: Efficient Join Query Evaluation in a Parallel Database System](https://homes.cs.washington.edu/~chushumo/files/sigmod_15_join.pdf). Shumo Chu, Magda Balazinska and Dan Suciu *SIGMOD 2015*

Gaussian Mixture Modeling (GMM) is a common type of analysis applied to increasingly large datasets. In working with scientists at the University of Washington, we encounter use case for GMM in astronomy. We implement this algorithm in the Myria shared-nothing relational data management system, which performs the computation in memory. We study resulting memory utilization challenges and implement several optimizations that yield an efficient and scalable solution. Empirical evaluations on large astronomy and oceanography datasets confirm that our Myria approach scales well and performs up to an order of magnitude faster than Hadoop.

* [Gaussian Mixture Models Use-Case: In-Memory Analysis with Myria](http://homes.cs.washington.edu/~maas/papers/maas-myriagmm.pdf). Ryan Maas, Jeremy Hyrkas, Olivia Grace Telford, Magdalena Balazinska, Andrew Connolly, and Bill Howe. *IMDM 2015 (at VLDB)*

