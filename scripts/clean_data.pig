REGISTER 'hdfs:///tmp/gini/pigudf.jar';
DEFINE TRIM edu.rosehulman.wangc6.Trim();
r = load '/tmp/gini/input/gini-index.csv' using PigStorage() as (s:chararray);
c = FOREACH r GENERATE TRIM(s) as cs;
Store c into '/tmp/gini/input/cgini'using PigStorage(',');

-- raw = load 'gini-index.csv' using PigStorage(',') as (namse:chararray,code:chararray,year:int,value:float)