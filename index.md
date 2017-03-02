---
layout: default
title: Myria Python/Jupyter
group: "docs"
weight: 4
section: 2
---

# Myria Python

Myria-Python is a Python interface to the [Myria project](http://myria.cs.washington.edu), a distributed, shared-nothing big data management system and Cloud service from the [University of Washington](http://www.cs.washington.edu).

The Python components include intuitive, high-level interfaces for working with Myria, along with lower-level operations for interacting directly with the Myria API.

Developers interact with the Myria system using `MyriaConnection` instances to establish a connection to the database, `MyriaQuery` instances to issue queries and obtain results, and `MyriaRelation` instances to interact with stored data.  Data may be uploaded in a variety of formats via a URL or the local file system.  Downloaded data may be easily converted into Python dictionaries, Pandas dataframes, and Numpy arrays.  A general workflow might involve the following high-level steps:

![Myria-Python Workflow](https://raw.githubusercontent.com/uwescience/myria-python/master/ipnb%20examples/overview.png "Myria-Python Workflow")

Myria-Python is also compatible with [Jupyter (IPython) Notebooks](http://jupyter.org/). See the section below for examples.

#### Quick Start Example

The following example illustrates a subset of the functionality available in the Myria Python library:

```python
from myria import *

## Establish a default connection to Myria
MyriaRelation.DefaultConnection = MyriaConnection(rest_url='http://demo.myria.cs.washington.edu:8753')

## Higher-level interaction via relation and query instances
query = MyriaQuery.submit(
    """books = load('https://raw.githubusercontent.com/uwescience/myria-python/master/ipnb%20examples/books.csv',
                csv(schema(name:string, pages:int)));
   longerBooks = [from books where pages > 300 emit name];
   store(longerBooks, LongerBooks);""")

# Download relation and convert it to JSON
json = query.to_dict()

# ... or download to a Pandas Dataframe
dataframe = query.to_dataframe()

# ... or download to a Numpy array
dataframe = query.to_dataframe().as_matrix()

## Access an already-stored relation
relation = MyriaRelation(relation='LongerBooks')
print len(relation)

## Lower-level interaction via the REST API
connection = MyriaConnection(rest_url='http://demo.myria.cs.washington.edu:8753')
datasets = connection.datasets()
```

## Installation

Users can install the Python libraries using `pip install myria-python`. Developers should clone the [repository](https://github.com/uwescience/myria-python) and run `python setup.py develop`.

## Using Python with the Myria Service

### Part 1: Running Queries

In this Python example, we query the smallTable relation by creating a `count(*)` query.  In this query, we store our result to a relation called dataCount. To learn more about the Myria query language, check out the [MyriaL](http://myria.cs.washington.edu/docs/myrial.html) page.

```python
from myria import *
connection = MyriaConnection(rest_url='http://demo.myria.cs.washington.edu:8753')

query = MyriaQuery.submit("""
  data = load('https://raw.githubusercontent.com/uwescience/myria/master/jsonQueries/getting_started/smallTable',
              csv(schema(left:int, right:int)));
  q = [from data emit count(*)];
  store(q, dataCount);""", connection=connection)

print query.to_dict()
```

### Part 2: Downloading Data

In the previous example we downloaded the result of a query.  We can also download data that has been stored as a relation:

```python
from myria import *
connection = MyriaConnection(rest_url='http://demo.myria.cs.washington.edu:8753')

# Load some data and store it in Myria
query = MyriaQuery.submit("""
  data = load('https://raw.githubusercontent.com/uwescience/myria/master/jsonQueries/getting_started/smallTable',
              csv(schema(left:int, right:int)));
  store(data, data);""", connection=connection)

# Now access previously-stored data
relation = MyriaRelation('data', connection=connection)

print relation.to_dict()[:5]
```

### Part 3: Uploading Data

#### 1. From a local Python variable

```python
from myria import *

name = {'userName': 'public', 'programName': 'adhoc', 'relationName': 'Books'}
schema = { "columnNames" : ["name", "pages"],
           "columnTypes" : ["STRING_TYPE","LONG_TYPE"] }

data = """Brave New World,288
Nineteen Eighty-Four,376
We,256"""

connection = MyriaConnection(rest_url='http://demo.myria.cs.washington.edu:8753')
result = connection.upload_file(
    name, schema, data, delimiter=',', overwrite=True)

relation = MyriaRelation("Books", connection=connection)
print relation.to_dict()
```

#### 2. From a Local File

```python
import sys
import urllib
import random
from myria import *

connection = MyriaConnection(rest_url='http://demo.myria.cs.washington.edu:8753')

# Download a sample file to our local filesystem
urllib.urlretrieve ("https://raw.githubusercontent.com/uwescience/myria-python/master/ipnb%20examples/books.csv",
                    "books.csv")

# Initialize a name and schema for the new relation
name = {'userName': 'public',
        'programName': 'adhoc',
        'relationName': 'Books' + str(random.randrange(sys.maxint)) } # Name must be unique!
schema = { "columnNames" : ["name", "pages"],
           "columnTypes" : ["STRING_TYPE","LONG_TYPE"] }

# Now upload that file to Myria
with open('books.csv') as f:
    connection.upload_fp(name, schema, f)

# Now access the new relation
relation = MyriaRelation(name, connection=connection)
print relation.to_dict()
```

#### 3. From the Command Line

In the example below, we upload a local CSV file to the Myria Service. Here is an example you can run through your terminal (assuming you've setup myria-python):

```shell
wget https://raw.githubusercontent.com/uwescience/myria/master/jsonQueries/getting_started/smallTable
myria_upload --overwrite --hostname demo.myria.cs.washington.edu --port 8753 --no-ssl --relation smallTable smallTable
```

#### 4. Loading Large Datasets In Parallel
Myria can upload a relation in parallel. Each worker must point to a partition of the file. Users must either create or have these partitions prepared in S3. In the example below, worker 1 reads the first part of the file (TwitterK-part1.csv) while worker 2 reads the last part of the file (TwitterK-part2.csv).

```python
from myria import *

connection = MyriaConnection(rest_url='http://demo.myria.cs.washington.edu:8753')
schema = MyriaSchema({"columnTypes" : ["LONG_TYPE", "LONG_TYPE"], "columnNames" : ["follower", "followee"]})
relation = MyriaRelation('parallelLoad', connection=connection, schema=schema)

# A list of worker-URL pairs -- must be one for each worker
work = [(1, 'https://s3-us-west-2.amazonaws.com/uwdb/sampleData/TwitterK-part1.csv'),
        (2, 'https://s3-us-west-2.amazonaws.com/uwdb/sampleData/TwitterK-part2.csv')]

# Upload the data (CSV is the default upload type)
query = query = MyriaQuery.parallel_import(relation=relation, work=work)

print query.status
```

## Using Myria with IPython

Myria exposes convenience functionality when running within the Jupyter/IPython environment.  See [our sample IPython notebook](https://github.com/uwescience/myria-python/blob/master/ipnb%20examples/myria%20examples.ipynb) for a live demo.

#### 1. Load the Extension

```python
%load_ext myria
```

#### 2. Connect to Myria

```python
%connect http://demo.myria.cs.washington.edu:8753
```

#### 3. Execute Queries

```python
%%query
books = load('https://raw.githubusercontent.com/uwescience/myria-python/master/ipnb%20examples/books.csv',
             csv(schema(name:string, pages:int)));
longerBooks = [from books where pages > 300 emit name];
store(longerBooks, LongerBooks);
```

#### 4. Variable Binding

You can embed local Python variables into a query expression.  For example, assume we have set the following local variables:

```python
low, high, name = 300, 1000, 'MyBooks'
```

Now we can execute a query in an IPython notebook that binds over our local environment:

```python
%%query
books = load('https://raw.githubusercontent.com/uwescience/myria-python/master/ipnb%20examples/books.csv',
             csv(schema(name:string, pages:int)));
longerBooks = [from books where pages > @low and pages < @high emit name];
store(longerBooks, @name);
```

# MyriaL

The above examples use MyriaL. For more information, please see [http://myria.cs.washington.edu/docs/myrial.html](http://myria.cs.washington.edu/docs/myrial.html).
