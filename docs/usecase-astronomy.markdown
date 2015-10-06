---
layout: default
title: Myria N-body Use Case
group: "extra"
weight: 0
---

# N-body Use Case

## Ingesting Data
To ingest simulation data into Myria, you can either upload data in Tipsy or NChilada format. We detail instructions for each below. Before you start, make sure to clone the following repository: [MyMergerTree](https://github.com/uwdb/MyMergerTree)

* Install Myria-Python and Raco
	* Navigate to ```/MyMergerTree/libs/raco``` folder and run ```python setup.py install```. Might need to use sudo.
	* Also run ```pip install myria-python```

* Tipsy
	* First, upload your files to vega@cs.washington.edu. Please contact the myria-users mailing list at myria-users@cs.washington.edu to reqest access. 
	* From the repository, navigate to ```/MyMergerTree/ingest/ingest_tipsy```. Here, you will find a file called ```generate_ingest_template.sh```. In this file, replace lines 4-10 with information about your dataset. Below we describe each parameter:
		- DATA_PATH: location of the tipsy files in vega
		- IORD: name of the file extension for iord files
		- GRP: name of the file extension for grp files
		- SIMULATION_PREFIX: name of the prefix for each file
		- SNAPSHOT_LIST: list of snapshots in the simulation
		- USER_NAME: the desired username for the relations that will be ingested into Myria
		- PROGRAM_NAME: the desired program name for the relations that will be ingested into Myria
	* Once filled out, run the ```generate_ingest_template.sh``` bash file. This will create a bash file called ```ingest_all_cosmo.sh``` along with a series of ingest files for each snapshot. Running ```ingest_all_cosmo.sh``` will run each ingest sequentially. Check the progress of the ingest [here](https://myria-web.appspot.com/queries).
	* Once ingested, you will need to repartition the snapshot data among the workers. To do this, go to ```/MyMergerTree/ingest/partition_tipsy``` directory. Here, open the ```partition_snapshots.py``` file and fill out the following information:
		- SNAPSHOT_LIST: the list of snapshots ingested
		- USER_NAME: the username used during ingest
		- PROGRAM_NAME: the program name used during ingest
	* Once filled out, running the python file will sequentially hash partition each snapshot.

* NChilada
	* Coming soon

## Running Queries
* Step 1: Creating Edges and Nodes
 * In order to create the merger trees, you will need to create the edges and the nodes first. First go to ```/MyMergerTree/queries```. Here, you will need to open ```create_edges.py``` and ```create_nodes.py`` and fill out the parameters at the top of the files. The parameters for SNAPSHOT\_LIST, USER\_NAME and PROGRAM\_NAME stay the same as before. For the new parameters:
	- DM\_SOL\_UNIT: the dmsolunit for the simulation
	- NON\_GRP\_PARTICLES: the group number of the particles that do not belong to a group (i.e. -1 or 0)
	- IORDER: the name of the iOrder column (i.e. Might be iord or iOrder depending on the simulation)
  * Run ```create_edges.py``` and ```create_nodes.py``` files in any order
* Step 2: Creating Custom Filter Queries
  * You can create queries to filter the edges and nodes table (named edgesTable and nodesTable respectively). Examples coming soon.

* Step 3: Prepare Data for Visualization
  * After filtering edges, open the ```queries_for_visualization.py``` file. Here, there are two new parameters, NODES\_RELATION and EDGES\_RELATION. This depends on the relation names for the resulting nodes and edges relations you generated after the filters. Once you run this python file, you can visualize the results.

## Example Custom Queries

## Using the MyMergerTree Visualization