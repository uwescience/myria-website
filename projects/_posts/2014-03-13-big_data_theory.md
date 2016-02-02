---
layout: default
title: Big Data Management Theory
date: 2015-12-12
excerpt: "New models of computation for big data processing"
id: "bigdatatheory"
---

## {{ page.title }}

We are studying the foundations of efficient Big Data management, which leads to new fundamental results regarding the complexity of various ad hoc data transformations in modern massive-scale parallel systems.

Our model of computation is an extension of the Massively Parallel (MPC) model, where computation is performed by p severs that alternate between local computation and re-shuffling steps, and each server is limited to O(n/p) space, where n is the size of the data. We study the time/space complexity of data transformations and extensions to cope with failures.

* [Worst-Case Optimal Algorithms for Parallel Query Processing]({{site.baseurl}}/publications/worstcase-beame.pdf). Paul Beame, Paraschos Koutris, Dan Suciu. *ICDT 2016*.
* [Query Processing for Massively Parallel Systems]({{site.baseurl}}/publications/thesis-koutris.pdf). Paraschos Koutris. *Ph.D. Dissertation, 2015*
* [Skew in Parallel Query Processing]({{site.baseurl}}/publications/skew-beame.pdf). Paul Beame, Paraschos Koutris, Dan Suciu. *PODS 2014*.
* [Communication steps for parallel query processing]({{site.baseurl}}/publications/communication-beame.pdf). Paul Beame, Paraschos Koutris, Dan Suciu. *PODS 2013*.
* [Parallel Evaluation of Conjunctive Queries]({{site.baseurl}}/publications/parallel-koutris.pdf). Paraschos Koutris, Dan Suciu. *PODS 2011*.
