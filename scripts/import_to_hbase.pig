giniData = LOAD 'hdfs:///tmp/gini/input/cleanedindex.txt' USING PigStorage('\t') AS (
           row_key:chararray,
           country_name:chararray,
           country_code:chararray,
           year:int,
           value:float
);

-- populationData = LOAD 'hdfs:///tmp/new-gini-index.txt' USING PigStorage('\t') AS (
--            row_key:chararray,
--            country_name:chararray,
--            country_code:chararray,
--            year:int,
--            value:float
-- );

-- To dump the data from PIG Storage to stdout
 dump giniData; 

-- Use HBase storage handler to map data from PIG to HBase
--NOTE: In this case, custno (first unique column) will be considered as row key.

STORE giniData INTO 'hbase://gini_index' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage(
'country:country_name
 country:country_code 
 value:year 
 value:value'
);

