-- TODO
gini = LOAD 'datasets/gini.txt' USING PigStorage ('\t') 
        AS (name:chararray, code:chararray, year:int, value:float);

STORE gini INTO 'datasets/gini.csv' USING PigStorage(',');