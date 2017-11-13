---
layout: default
title: "Source Code"
group: "projects"
weight: 2
---

# Source Code

## Myria 

Myria is our novel cloud service for big data management and analytics designed to improve productivity. Myria’s goal is for users to simply upload their data and for the system to help them be self-sufficient data science experts on their data. Myria queries are executed on a scalable, parallel cluster that uses both state-of-the-art and novel methods for distributed query processing.

To get Myria up and running, you can view the source [here](https://github.com/uwescience/myria). The source code used to deploy Myria on Amazon can be found [here](https://github.com/uwescience/myria-ec2-ansible).

Developers, please see our "Myria for Developers" sections under the 'Documentation' menu.

## PipeGen

PipeGen allows users to automatically create an efficient connection between pairs of database systems. PipeGen targets data analytics workloads on shared-nothing engines, and supports scenarios where users seek to perform different parts of an analysis in different DBMSs or want to combine and analyze data stored in different systems. The systems may be colocated in the same cluster or may be in different clusters.

The PipeGen source code is located [here](https://github.com/uwdb/pipegen).

## PSLAManager

Today's pricing models and SLAs are described at the level of compute resources (instance-hours or gigabytes processed). This makes it difficult for users to select a service, pick a configuration, and predict the actual analysis cost. To address this challenge, we propose a new abstraction, called a Personalized Service Level Agreement (PSLA), where users are presented with what they can do with their data in terms of query capabilities, guaranteed query performance and fixed hourly prices.

Source to generate these PSLAs can be found [here](https://github.com/uwdb/PSLAManager).

