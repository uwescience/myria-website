---
layout: default
title: Big Data Management as a Cloud Service
date: 2015-09-12
excerpt: Multi-tenancy, resource allocation, architecture, and cost optimization
id: "cloudservice"
---

## {{ page.title }}

An important focus of Myria is not just on managing Big Data but on doing so using a Cloud service. We are thus studying various aspects of this problem. 

### PSLA

We are studying a new type of SLA that will enable Cloud providers to offer Big Data Management and Analytics as a service with a more user-friendly and performance-friendly service-level agreement (SLA).

Today's pricing models and SLAs are described at the level of compute resources (instance-hours or gigabytes processed). They are also different from one service to the next. Both conditions make it difficult for users to select a service, pick a configuration, and predict the actual analysis cost. To address this challenge, we propose a new abstraction, called a Personalized Service Level Agreement (PSLA), where users are presented with what they can do with their data in terms of query capabilities, guaranteed query performance and fixed hourly prices.

* [A Vision for Personalized Service Level Agreements in the Cloud]({{site.baseurl}}/publications/Ortiz_PSLA_2013.pdf). Jennifer Ortiz, Victor T. Almeida, Magda Balazinska. *SIGMOD Workshop on Data Analytics in the Cloud (DanaC) 2013*.

* [Changing the Face of Database Cloud Services with Personalized Service Level Agreements]({{site.baseurl}}/publications/Ortiz_PSLA_CIDR_2015.pdf). Jennifer Ortiz, Victor T. Almeida, Magda Balazinska. *CIDR 2015*.

The source code for PSLAManager can be found [here](https://github.com/uwdb/PSLAManager)

<iframe width="500" height="281" src="//www.youtube.com/embed/f1dJfQXyT7A" frameborder="0" allowfullscreen></iframe>

### PerfEnforce

* [PerfEnforce Demonstration: Data Analytics with Performance Guarantees]({{site.baseurl}}/publications/Ortiz-perfenforceDemo-sigmod16.pdf). Jennifer Ortiz, Brendan Lee, Magda Balazinska. *SIGMOD 2016*.
* [PerfEnforce: A Dynamic Scaling Engine for Analytics with Performance Guarantees](https://arxiv.org/abs/1605.09753). Jennifer Ortiz, Brendan Lee, Magda Balazinska, Joseph L. Hellerstein. *arXiv 2016*

You can try out the PSLAManager and PerfEnforce systems when launching Myria on EC2. Simply launch the cluster with the `--perfenforce` flag as follows: `myria-cluster create test-cluster --perfenforce`. Please note that launching a cluster with this command will automatically provision 12 m4.xlarge machines. 

<iframe width="500" height="281" src="//www.youtube.com/embed/H68HHOkDTU4" frameborder="0" allowfullscreen></iframe>


### Elastic Container Memory Management

* [Toward Elastic Memory Management for Cloud Data Analytics](https://homes.cs.washington.edu/~jwang/publications/elastic-memory.pdf). Jingjing Wang and Magdalena Balazinska. *BeyondMR 2016*.  [(slides)](https://homes.cs.washington.edu/~jwang/publications/elastic-memory-beyondmr2016-slides.pdf)




