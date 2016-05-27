---
layout: default
title: REST API
group: "docs"
weight: 3
section: 4
---

## Myria REST API

Documentation for the Myria REST API 

* Ingest a new dataset <br>
```curl -i -XPOST {SERVER}:{PORT}/dataset -H "Content-type: application/json" -d @./data.json```

* Download data <br>
```curl -i -XGET {SERVER}:{PORT}/dataset/user-{USER}/program-{PROGRAM}/relation-{RELATION}/data?format=json```

* Get datasets that match a search term <br>
```curl -i -XGET {SERVER}:{PORT}/dataset/search?q=searchTerm```

* Get a list of datasets for a user <br>
```curl -i -XGET {SERVER}:{PORT}/dataset/user-{USER}```

* Get a list of datasets for a user <br>
```curl -i -XGET {SERVER}:{PORT}/dataset/user-{USER}/program-{PROGRAM}```

* Gets all the workers in the cluster <br>
```curl -i -XGET {SERVER}:{PORT}/workers```

* Gets all the workers that are alive <br>
```curl -i -XGET {SERVER}:{PORT}/workers/alive```

* Gets more info for a particular worker <br>
```curl -i -XGET {SERVER}:{PORT}/workers/worker-workerId```

## Radish REST API 
