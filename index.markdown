---
layout: default
title: Myria - Big Data Management as a Cloud Service
---

<h1 id="overview">Overview</h1>

{% include overview.markdown %}

<h1 id="people">People</h1>

{% include people.markdown %}

<h1 id="publications">Projects, Publications, and Software</h1>

We are tackling several inter-related challenges:

## Big Data Management Theory

We are studying the theory of efficient Big Data management, which leads to new fundamental results regarding the complexity of various ad hoc data transformations in modern massive-scale systems.

Our model of computation is an extension of our recent Massively Parallel (MP) model, where computation is performed by P severs that alternate between computation and re-shuffling steps, and each server is limited to O(n/P) space, where n is the size of the data. We study the time/space complexity of data transformations and extensions to cope with failures.

## Big Data Query languages

{% include languages.markdown %}

## Systems-challenges of Efficient Big Data Management

We are studying a variety of challenges related to building systems for efficient Big Data management. A large fraction of this work is done in the context of the [Nuage project](http://nuage.cs.washington.edu). We are also tackling challenges related to the usability of Big Data systems in the [CQMS project](http://cqms.cs.washington.edu/).

In the specific context of the Myria project, we started to focus on challenges associated with efficient iterative processing. In particular, failures and load imbalances are increasingly common as the size of data processing tasks grows, and exacerbated in iterative programs. In prior work, we have extensively studied both problems for non-iterative computations. For iterative programs, we propose a radically new, extremely lightweight approach, which we call FT/Skew Skip Mechanism: when a server fails, we simply allow the other servers to continue the iteration. The failed computation either re-joins eventually, after recovery; or is abandoned altogether, if the resulting accuracy is still acceptable. We treat skew as a form of failure: servers that are too slow to respond are assumed to have failed. We are studying this approach and other light-weight fault-tolerance and load balance techniques for iterative computations.

## Big Data Management as a Cloud Service

{% include sla.markdown %}

## MyriaDB System and Service

All the above ideas are brought together in a new Big Data management system called MyriaDB that we are currently building as a cloud service.


<h1 id="usecases">Use-Case Repository</h1>

In order to facilitate Big Data research in academia and research labs, we are assembling a variety of real uses-cases and known benchmarks and base our experiments and feature requirements on real use-cases from a variety of domains, primarily various domain sciences. To help the community, we are making these use-cases publicly available. Each use-case comprises data and examples of the processing to be done on that data.

This effort is brought to you by the University of Washington [database group](http://db.cs.washington.edu), [AstroDB team](http://db.cs.washington.edu/astrodb/), [Survey Science group,](http://ssg.astro.washington.edu/home_ssg.shtml)[ N-body Shop](http://www-hpcc.astro.washington.edu/), [eScience Institute](http://escience.washington.edu/), and the [Big Data ](http://bigdata.cs.washington.edu)group.

We also have an older [repository of Hadoop applications](http://nuage.cs.washington.edu/repository.php) as part of our earlier [Nuage project](http://nuage.cs.washington.edu).

<a class="btn btn-primary" href="{{ site.baseurl}}/repository/">Open use-case repository...</a>

<h1 id="ack">Acknowledgments</h1>

The Myria project is partially supported by the National Science Foundation through [NSF grant IIS-](http://www.nsf.gov/awardsearch/showAward.do?AwardNumber=1247469)[1247469](https://www.fastlane.nsf.gov/researchadmin/viewProposalStatusDetails.do?propId=1247469&amp;performOrg=U of Washington "View Status for Proposal Number 1247469"), gifts from [EMC](http://www.emc.com), and the [Intel Science and Technology Center for Big Data](http://istc-bigdata.org). Any opinions, findings, and conclusions or recommendations expressed in this material are those of the author(s) and do not necessarily reflect the views of the funding agencies.