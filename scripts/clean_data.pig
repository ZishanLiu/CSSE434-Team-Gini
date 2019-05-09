REGISTER 'hdfs:///tmp/gini/pigudf.jar';
DEFINE TRIM edu.rosehulman.wangc6.Trim();
r = load '/tmp/gini/input/raw/gini-index.csv' using PigStorage() as (s:chararray);
c = FOREACH r GENERATE TRIM(s) as cs;
Store c into '/tmp/gini/input/cleaned/cgini'using PigStorage(',');