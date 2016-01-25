---
layout: default
title: MyriaL Language Reference
weight: 3
---
MyriaL Language Reference
=========================

***This is work in progress***

##hello world
##reading input
 
###load
Reading a csv file via load

T1 =LOAD("https://s3-us-west-2.amazonaws.com/uwdb/sampleData/TwitterK.csv", csv(schema(a:int, b:int),skip=0));

points = load("https://s3-us-west-2.amazonaws.com/uwdb/sampleData/sampleCrossmatch/points.txt",
              csv(schema(id:int,
                         x:float,
                         y:float,
                         z:float), skip=0));

##saving results
###store

STORE(sourceRelation, DestinationRelation, optional[PartitionAttribute])

STORE(T1, TwitterK, [a, b];
STORE(T1, TwitterK, [$0,$1);
STORE(T2, points, [x,y,z])


*MyriaL needs explicit partition attribute specified for a relation uploaded via load operator, once this issue is fixed, partition attribute will not need to be specifed.*


##transforming data
###comprehensions
###SQL
__Create an empty relation with a particular schema__

newRelation = empty(x:float, y:float, z:float);


###scan
T1 = SCAN(relationName);

T1 = SCAN(TwitterK);


###aggregation
T1 = SCAN(TwitterK);

Groups = [FROM T1 EMIT COUNT(a) AS cnt, T1.a AS id];
STORE(Groups, OUTPUT, [$1]);

###join 
T1 = SCAN(TwitterK);
T2 = SCAN(TwitterK);

Joined = [FROM T1, T2
          WHERE T1.$1 = T2.$0
          EMIT T1.$0 AS src, T1.$1 AS link, T2.$1 AS dst];
          
STORE(Joined, TwoHopsInTwitter);


###union
'+' is a union operator in MyriaL
T2 =  SCAN(TwitterK);
T3 = SCAN(TwitterK);

result = T2+T3;



##expressions
###arithmetic
T3 = [FROM T1 EMIT sin(a)/4 + b AS x];

__Unicode math operators ≤, ≥, ≠__

out = [FROM TwitterK WHERE $0 ≤ $1 and $0 ≠ $1 and $1 ≥ $0 EMIT *];


###constants
__A constant as a singleton relation__

N = [2];

###literals
##loops

DO
  stats = [FROM points EMIT avg(x) AS mean, stdev(x) AS std];
  NewBad = [FROM points, stats WHERE abs(x - mean) > N * std EMIT points.*];
  points = diff(points, NewBad);
  continue = [FROM NewBad EMIT count(NewBad.x) > 0];
WHILE continue;


##functions
__User-defined function to calculate modulo operation__

 def mod(x, n): x - int(x/n)*n;

 
 __User-defined aggregate function__
 
apply RunningMean(value) {
      -- initialize the custom state, set cnt = 0 and summ = 0
      [0 AS cnt, 0 AS summ];
      -- for each record, add one one to the count (cnt) and add the record value to the sum (summ)
      [cnt + 1 AS cnt, summ + value AS summ];
      -- on each record, produce the running sum divided by the running count
      s / c;
};

##stateful apply
##comments
Myria Catalog is case sensitive.
