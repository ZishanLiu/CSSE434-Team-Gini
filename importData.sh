rm -f datasets/cleaned/*
hadoop fs -mkdir /tmp/gini
hadoop fs -rm -r /tmp/gini/input
hadoop fs -mkdir /tmp/gini/input
hadoop fs -mkdir /tmp/gini/input/raw
hadoop fs -put datasets/raw/* /tmp/gini/input/raw
hadoop fs -rm -r /tmp/gini/input/cleaned
hadoop fs -mkdir /tmp/gini/input/cleaned
pig -x mapreduce scripts/clean_data.pig 
hadoop fs -get /tmp/gini/input/cleaned/cgini/part-m-00000 datasets/cleaned/gini.csv
