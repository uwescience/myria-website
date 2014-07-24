---
layout: default
title: Use-Case Repository
group: "navigation"
rank: 3
---

# Use-Case Repository

In order to facilitate Big Data research in academia and research labs, we are assembling a variety of real uses-cases and known benchmarks and base our experiments and feature requirements on real use-cases from a variety of domains, primarily various domain sciences. To help the community, we are making these use-cases publicly available. Each use-case comprises data and examples of the processing to be done on that data.

This effort is brought to you by the University of Washington [database group](http://db.cs.washington.edu), [AstroDB team](http://db.cs.washington.edu/astrodb/), [Survey Science group,](http://ssg.astro.washington.edu/home_ssg.shtml)[ N-body Shop](http://www-hpcc.astro.washington.edu/), [eScience Institute](http://escience.washington.edu/), and the [Big Data ](http://bigdata.cs.washington.edu)group.

We also have an older [repository of Hadoop applications](http://nuage.cs.washington.edu/repository.php) as part of our earlier [Nuage project](http://nuage.cs.washington.edu).

## MyMergerTree Use-Case

MyMergerTree is a vertical service built on top of Myria to facilitate the study of the formation of galaxies through the visualization of galactic merger trees. By utilizing Myria's REST API to compute these trees, we can provide astronomers with interactive visualizations to dramatically improve the speed and efficiency of their data analysis. Below are the MyMergerTree demo, part of the Myria demo at SIGMOD 2014, and links to the demo's poster and to the MyMergerTree paper presented at the DanaC Workshop at SIGMOD 2014.

* [MyMergerTree Service: Creating Galactic Merger Trees using Myria]({{site.baseurl}}/repository/MyMergerTree/MyMergerTreePoster.pdf). Presented by Laurel Orr, Sarah Loebman, Jennifer Ortiz, and Daniel Halperin. Demo poster at *SIGMOD 2014*.
* [Big-Data Management Use-Case: A Cloud Service for Creating and Analyzing Galactic Merger Trees]({{site.baseurl}}/repository/MyMergerTree/MyMergerTree_DanaC_2014.pdf). Sarah Loebman, Jennifer Ortiz, Lee Lee Choo, Laurel Orr, Lauren Anderson, Daniel Halperin, Magdalena Balazinska, Thomas Quinn, and Fabio Governato. *SIGMOD Workshop on Data Analytics in the Cloud (DanaC) 2014*.

<iframe width="853" height="480" src="//www.youtube.com/embed/RMEKp_BUcfQ" frameborder="0" allowfullscreen></iframe>

## UW-CAT: University of Washington CoAddition Testing Use-Case

* **Name**: Please refer to this dataset/use-case as the **UW-CAT** dataset/use-case.
* **Acknowledgment and citation** : [See detailed description.]({{ site.baseurl}}/repository/uw-cat.html)
* **Tags**: Why is this use-case interesting? It is: (1) Iterative (2) High Volume and (3) Embarrassingly Parallel

**Short Description**: This use-case involves processing astronomy data in the form of 2D images output by a telescope. The 2D images are stacked together to form a 3D array with `(x,y,t)` coordinates where `(x,y)` are the pixel positions and `t` is the time dimension. Several data analysis tasks are then performed on this 3D array. For now, we focus on the simplest type of analysis: An iterative data cleaning algorithm, called "Sigma-Clipping", followed by a co-addition operation. The goal of this analysis is to detect faint sources (a "source" can be a galaxy, a star, etc.), too faint to be seen on a single image, but bright enough to appear on the co-added image. The illustrative comparison of one single image and its corresponding co-added image is shown below. There are many faint objects that show up in the co-added image but not in the single image. The sigma-clipping phase serves to clean-out outliers before the co-addition step.

**Detailed description**: [Link to data and detailed description.]({{ site.baseurl}}/repository/uw-cat.html)


## Seaflow

coming soon...

## N-Body Simulation

coming soon...

