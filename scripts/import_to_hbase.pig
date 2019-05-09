input_file = LOAD '/tmp/gini/input/cleaned/gini.csv' USING PigStorage(',') AS (
           country_name:chararray,
           country_code:chararray,
           year:int,
           value:float
);
finput = filter input_file by country_name != 'Country Name';
hinput = foreach finput generate CONCAT(country_code,'_',(chararray)year) as row_key, country_name as name, country_code as code, year as year, value as value;


-- Use HBase storage handler to map data from PIG to HBase

STORE hinput INTO'hbase://gini' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage(
'country:country_name
 country:country_code 
 value:year 
 value:value'
);