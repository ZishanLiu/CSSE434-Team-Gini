# assume that the udf is already in hdfs.
# $1 = input for raw gini index data.

# set up hadoop direcotry
rm -f datasets/cleaned/*
hadoop fs -mkdir /tmp/gini
hadoop fs -rm -r /tmp/gini/input
hadoop fs -mkdir /tmp/gini/input
hadoop fs -mkdir /tmp/gini/input/raw
hadoop fs -mkdir /tmp/gini/input/cleaned
# put raw data to hdfs
hadoop fs -put $1 /tmp/gini/input/raw
# clean the raw data
pig -x mapreduce -p udf_location=hdfs:///tmp/gini/pigudf.jar -p inputpath=/tmp/gini/input/raw/gini-index.csv -p outputpath=/tmp/gini/input/cleaned/cgini scripts/clean_data.pig 
# place the cleaned data to certain locations
hadoop fs -get /tmp/gini/input/cleaned/cgini/part-m-00000 datasets/cleaned/gini.csv
hadoop fs -rm -r /tmp/gini/input/cleaned/
hadoop fs -mkdir /tmp/gini/input/cleaned/
hadoop fs -put datasets/cleaned/* /tmp/gini/input/cleaned
# set up hbase table
echo -e "disable 'gini'" | hbase shell -n
echo -e "drop 'gini'" | hbase shell -n
echo -e "create 'gini','country','value'" | hbase shell -n
echo -e "enable 'gini'" | hbase shell -n
# import it to hbase
pig -x mapreduce -p hdfsinput=/tmp/gini/input/cleaned/gini.csv -p hbaseoutput=hbase://gini scripts/import_to_hbase.pig 
