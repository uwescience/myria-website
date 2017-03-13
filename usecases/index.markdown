---
layout: default
title: Use-Case Repository
group: "navigation"
id: "cases"
---

# Use-Case Repository

In order to facilitate Big Data research in academia and research labs, we are assembling a variety of real uses-cases and known benchmarks and base our experiments and feature requirements on real use-cases from a variety of domains, primarily various domain sciences. To help the community, we are making these use-cases publicly available. Each use-case comprises data and examples of the processing to be done on that data.

This effort is brought to you by the University of Washington [database group](http://db.cs.washington.edu), [AstroDB team](http://db.cs.washington.edu/astrodb/), [Survey Science group,](http://ssg.astro.washington.edu/home_ssg.shtml)[ N-body Shop](http://www-hpcc.astro.washington.edu/), [eScience Institute](http://escience.washington.edu/), and the [Big Data ](http://bigdata.cs.washington.edu)group.

We also have an older [repository of Hadoop applications](http://nuage.cs.washington.edu/repository.php) as part of our earlier [Nuage project](http://nuage.cs.washington.edu).

## Twitter Dataset and Queries

* **Data** : [The Original Dataset and Detailed Description.](https://an.kaist.ac.kr/traces/WWW2010.html)
* **Acknowledgment and citation** : [The Original Paper](https://an.kaist.ac.kr/~haewoon/papers/2010-www-twitter.pdf)
* **Tags**: Iterative, High Volume, Graph Queries

**Short Description**: This set of use-cases contains graph queries on a Twitter follower-followee graph. 

## UW-CAT: University of Washington CoAddition Testing Use-Case

* **Name**: Please refer to this dataset/use-case as the **UW-CAT** dataset/use-case.
* **Acknowledgment and citation** : [See detailed description.]({{ site.baseurl}}/usecases/uw-cat.html)
* **Tags**: Why is this use-case interesting? It is: (1) Iterative (2) High Volume and (3) Embarrassingly Parallel

**Short Description**: This use-case involves processing astronomy data in the form of 2D images output by a telescope. The 2D images are stacked together to form a 3D array with `(x,y,t)` coordinates where `(x,y)` are the pixel positions and `t` is the time dimension. Several data analysis tasks are then performed on this 3D array. For now, we focus on the simplest type of analysis: An iterative data cleaning algorithm, called "Sigma-Clipping", followed by a co-addition operation. The goal of this analysis is to detect faint sources (a "source" can be a galaxy, a star, etc.), too faint to be seen on a single image, but bright enough to appear on the co-added image. The illustrative comparison of one single image and its corresponding co-added image is shown below. There are many faint objects that show up in the co-added image but not in the single image. The sigma-clipping phase serves to clean-out outliers before the co-addition step.

**Detailed description**: [Link to data and detailed description.]({{ site.baseurl}}/usecases/uw-cat.html)

## Seaflow

coming soon...

## Music Information Retrieval over the Million Song Dataset

* **Data** : [The Original Dataset](http://labrosa.ee.columbia.edu/millionsong/)
* **Analysis** : [2012 Nature Paper](http://www.nature.com/srep/2012/120726/srep00521/full/srep00521.html)
* **Tags**: Why is this use-case interesting? It requires: (1) large aggregation queries (2) graph analysis (3) statistical methods, (4) time-series analysis, and (5) novel database operators and language features.

**Short description**: This use-case involves making the Million Song Dataset available in an easily queryable form, and implementing some common methods used in Music Information Retrieval so domain experts can conveniently analyze the data set. Many of these methods are drawn from a 2012 Nature paper analyzing the data set, linked above. We plan to reproduce many of the results in that paper by implementing new features in the underlying database and adding language features to MyriaL.

**Long description** : [Link to data and detailed description.]({{ site.baseurl}}/usecases/msd.html)

## Flights

* **Data** : [Bureau of Transportation Statistics](https://www.transtats.bts.gov/)
* **Tags**: Why is this use-case interesting? It has multiple GB of data, allows for interesting aggregate queries, and contains a variety of correlations between the attributes.

**Short description**: This use-case involves all flights in the United States from 1987 to present day. There are numerous categorical and continuous attributes for each flight. To download an entire month's worth of data by url, use http://www.transtats.bts.gov/Download/On_Time_On_Time_Performance_[year]_[month].zip.
