---
layout: default
title: Myria - Music Metadata Analysis Use-Case
---

# Music Analysis in Myria: Studying the Million Song Dataset

**Requests**: If you have any questions about this use-case, please contact [Jeremy Hyrkas](http://homes.cs.washington.edu/~hyrkas/).

## Overview of Application Domain

[Music Information Retrieval](https://en.wikipedia.org/wiki/Music_information_retrieval) (MIR) is a general term for analyzing musical audio
and metadata. MIR tasks span a variety of tasks, including recommendation systems, song tagging, mood detection, musicology and historical
analysis, and music generation.

The largest data public data set for MIR tasks is the [Million Song Dataset](http://labrosa.ee.columbia.edu/millionsong/). The data set
consists of song tags, track information, extracted audio information (such as beats, pitches, timbre, song sections), and other metadata
about one million songs. The information was extracted using [EchoNest](http://the.echonest.com/).

A [2012 Nature Paper](http://www.nature.com/srep/2012/120726/srep00521/full/srep00521.html) analysed musical trends across decades using
the Million Song Dataset. The paper's methods illusistrate some common tasks in MIR, such as beat-aligning features, song transposition,
and setting parameters by sampling and gathering statistics. These tasks are usually handled in MIR libraries in languages like Python.
However, to easily analyze music metadata at scale, we believe a different approach is necessary.

The goals of this use case are to take common MIR tasks and reimagine them in the context of a distributed database for scalability.
Some tasks will require new algorithms, but many will involve repurposing existing database and analytics tools for a new context.
The tasks we examine will include:

* Beat-synchronizing audio features
* Automatic song transposition
* Audio data normalization

Fully solving these tasks involves a combination of distributed database techniques, linear algebra operations and time-series analysis.
We also hope to make new language features that make it easy for new users to easily explore the data set.

