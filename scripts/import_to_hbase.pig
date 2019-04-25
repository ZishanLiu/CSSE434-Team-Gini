-- me your script Load_HBase_Customers.pig
-- Load dataset 'customers' from HDFS location

raw_data = LOAD 'hdfs:///tmp/new-gini-index.txt' USING PigStorage('\t') AS (
           row_key:chararray,
           country_name:chararray,
           country_code:chararray,
           year:int,
           value:float
);

-- To dump the data from PIG Storage to stdout
 dump raw_data; 

-- Use HBase storage handler to map data from PIG to HBase
--NOTE: In this case, custno (first unique column) will be considered as row key.

STORE raw_data INTO 'hbase://gini_index' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage(
'country:country_name
 country:country_code 
 value:year 
 value:value'
);

