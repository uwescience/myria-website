---
layout: default
title: Start Here
group: "docs"
weight: 2
section: 1
---

# Getting Started with Myria
This page covers the following topics:

* How to use the Myria demonstration service hosted by UW, from either the MyriaWeb front-end, the Python API, or an IPython notebook.
* How to set up your own Myria service, either on a local laptop, on-site cluster, or Amazon EC2.

Developers, please see our [Myria Developer](developer.html) page.

Questions? See our [FAQ](faq.html).

## Learning about the Myria stack

For a short overview of Myria as a cloud service and a big data management system, see our demo [paper](http://myria.cs.washington.edu/publications/Halperin_Myria_demo_SIGMOD_2014.pdf).

Check out the overview slides from the demonstration we gave in the eScience Community Seminar in May 2015:  [overview slides](./myria-overview-may2015.pdf).

The [Myria Middleware doc page](myriaMiddleware.html) has an excellent overview of how Myria's three components are designed and fit together: MyriaX, MyriaMiddleware and MyriaWeb.

## Using the Myria demonstration service

The UW Database Group hosts a demonstration Myria service: <http://demo.myria.cs.washington.edu>.
The demo service runs on Amazon EC2 and is a small version of Myria running on only four instances.
The demo service is there to make it easy to get a sense of what Myria is about, but don't use it to do any actual work
or test anything at scale.

See the following section for how to host an instance of the Myria service on your local computer or Amazon EC2.


### Using the Myria service through the browser


Open your browser (preferably Chrome), and point it at [http://demo.myria.cs.washington.edu](http://demo.myria.cs.washington.edu).

You will see an editor where you can write MyriaL or SQL queries and execute them with Myria.

Here is a quick tour of the interface:

- At the top of the screen, you should see three tabs: "Editor", "Queries", and "Datasets".
Click on the "Datasets" tab. Here, you can see the list of all the datasets currently ingested
and available in the service. You can click on the name of a dataset to see its metadata
including the schema.  Click on "JSON", "CSV", or "TSV" to download the dataset in the
specified format.

- Now click on the "Queries" tab. This is where you can see all the queries that yourself
and others have been running. Observe the keyword search window. After you have run the example
query below, for example, type the word "Twitter" to see all queries executed on the
`public:adhoc:Twitter` relation.

- Finally, click on the "Editor" tab. This is where you can write and execute queries.
You can start from one of the examples on the right. Click on the example and the
query will appear in the editor window. Queries can be written in SQL or MyriaL. We
recommend MyriaL because, in that mode, you can inter-twine SQL and MyriaL in your
script.

Try the following query, which ingests a dataset from S3, stores it in the relation `public:adhoc:Twitter`,
and computes an aggregate that it stores in a relation called `public:adhoc:Followers`:

    Twitter = LOAD("https://s3-us-west-2.amazonaws.com/myria/public-adhoc-TwitterK.csv", csv(schema(column0:int, column1:int), skip=1));
    STORE(Twitter, public:adhoc:Twitter, [$0]);
    Twitter = SCAN(public:adhoc:Twitter);
    Followers = SELECT $0, COUNT($1) FROM Twitter;
    STORE(Followers, public:adhoc:Followers, [$0]);

(The extra argument in the `STORE` statement means to hash-partition the data on the
first attribute and store it hash-partitioned across all worker instances.)

First click on "Parse". This will show you the query plan that Myria will
execute. Then click on "Execute Query". This will execute the query and
produce a link to the output.

Now select  the "Profile Query" option below the query window and
re-execute the query with the option ON.  Below the result, you will
see the "Profiling results". Click on it. It wil show you profiling information
about the way the query executed. Explore the output of the profiler.


### Using the Myria service from Python

For more complex analysis, it may be useful to interact with Myria using Python.

#### Part 1: Upload/Download Data

To upload data, this can be done through the [Python API](myria-python/index.html), under the "Using Python with the Myria Service" section.

#### Part 2: Running Queries on the Service

To start building queries once the data is uploaded, you can either write your queries directly through our [Myria Web Frontend](https://demo.myria.cs.washington.edu/editor) as demonstrated above, [Python](myria-python/index.html), or [IPython Notebook](https://github.com/uwescience/myria-python/blob/master/ipnb%20examples/myria%20examples.ipynb). To learn more about the Myria query language, check out the [MyriaL](myrial.html) page.


## Hosting your own Myria service

### Part 1: Setting up the service

Myria's relational execution engine, MyriaX, is designed to run in a shared-nothing cluster. It consists of
a coordinator process and a set of worker processes. The coordinator receives query
plans in JSON through a REST API and has the workers execute these query plans.

There are three ways to run MyriaX:

#### Run MyriaX in a public cloud (_recommended_)
  If you already have an AWS account, this is the recommended way to deploy a new Myria environment. The instructions to deploy MyriaX on Amazon EC2 are here: [Running Myria on Amazon EC2](https://github.com/uwescience/myria-ec2-ansible/blob/reef/README.md). Short version: download the `myria-deploy` script [here](https://raw.githubusercontent.com/uwescience/myria-ec2-ansible/reef/myria-deploy) and run it (use the `--help` option to see all options). The script will tell you how to install any missing dependencies. It does not require root privileges to run (although some of the dependencies require root privileges to install). When the script is done, you will have a working MyriaWeb instance that you can point your browser to and start running queries.

#### Run MyriaX locally on a laptop or desktop
  This is the easiest
way to experiment with MyriaX if you don't want to deploy on the public cloud. This setup is not designed
to deliver high performance. It should be thought of as an experimental
or debug mode. Instructions are here: [Running the MyriaX engine](myriax/index.html)

#### Run MyriaX in an existing cluster
  The instructions to run MyriaX on an existing cluster are here:  [Running the MyriaX engine](myriax/index.html).


### Part 2: Running queries on the service

After you set up MyriaX, you can upload data and run queries through the [Python API](myria-python/index.html) under the "Using Python with your own Myria Deployment" section. An alternative way to run queries is via the [MyriaWeb](myria-web/index.html) interface. Again, if you deploy to EC2 using the `myria-deploy` script, MyriaWeb will be set up for you.

## MyriaL Reference

The Myria query language, MyriaL, is documented [here](http://myria.cs.washington.edu/docs/myrial.html).

## Myria Use Cases

In addition to the [Python tutorial doc](myria-python/index.html) referenced above,
we are developing example real-world use cases here:

* [N-body](usecase-astronomy.html)

