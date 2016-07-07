---
layout: default
title: Big Data Management as a Cloud Service
date: 2015-09-12
excerpt: Multi-tenancy, resource allocation, architecture, and cost optimization
id: "cloudservice"
---

## {{ page.title }}

An important focus of Myria is not just on managing Big Data but on doing so using a Cloud service. We are thus studying various aspects of this problem. Specifically, we are studying a new type of SLA that will enable Cloud providers to offer Big Data Management and Analytics as a service with a more user-friendly and performance-friendly service-level agreement (SLA).

Today's pricing models and SLAs are described at the level of compute resources (instance-hours or gigabytes processed). They are also different from one service to the next. Both conditions make it difficult for users to select a service, pick a configuration, and predict the actual analysis cost. To address this challenge, we propose a new abstraction, called a Personalized Service Level Agreement (PSLA), where users are presented with what they can do with their data in terms of query capabilities, guaranteed query performance and fixed hourly prices.

* [A Vision for Personalized Service Level Agreements in the Cloud](../../publications/Ortiz_PSLA_2013.pdf). Jennifer Ortiz, Victor T. Almeida, Magda Balazinska. *SIGMOD Workshop on Data Analytics in the Cloud (DanaC) 2013*.

* [Changing the Face of Database Cloud Services with Personalized Service Level Agreements](../../publications/Ortiz_PSLA_CIDR_2015.pdf). Jennifer Ortiz, Victor T. Almeida, Magda Balazinska. *CIDR 2015*.

The source code for PSLAManager can be found [here](https://github.com/uwdb/PSLAManager)

<iframe width="500" height="281" src="//www.youtube.com/embed/f1dJfQXyT7A" frameborder="0" allowfullscreen></iframe>

* [PerfEnforce Demonstration: Data Analytics with Performance Guarantees](../../publications/Ortiz-perfenforceDemo-sigmod16.pdf). Jennifer Ortiz, Brendan Lee, Magda Balazinska. *SIGMOD 2016*.



