rm -f datasets/cleaned/*
hadoop fs -mkdir /tmp/gini
hadoop fs -rm -r /tmp/gini/input
hadoop fs -mkdir /tmp/gini/input
hadoop fs -mkdir /tmp/gini/input/raw
hadoop fs -mkdir /tmp/gini/input/cleaned
hadoop fs -put datasets/raw/* /tmp/gini/input/raw
pig -x mapreduce scripts/clean_data.pig 
hadoop fs -get /tmp/gini/input/cleaned/cgini/part-m-00000 datasets/cleaned/gini.csv
hadoop fs -rm -r /tmp/gini/input/cleaned/
hadoop fs -mkdir /tmp/gini/input/cleaned/
hadoop fs -put datasets/cleaned/* /tmp/gini/input/cleaned
echo -e "disable 'gini'" | hbase shell -n
echo -e "drop 'gini'" | hbase shell -n
echo -e "create 'gini','name','code','year','value'" | hbase shell -n
pig -x mapreduce scripts/import_to_hbase.pig 
