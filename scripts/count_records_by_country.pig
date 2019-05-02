data = LOAD 'hbase://gini_index' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage(
'country:name
 country:code
 value:year
 value:value','-loadKey false') AS (country_name:chararray, country_code:chararray, year:int, value:float);

countries = GROUP data by country_name;

records_by_country = FOREACH countries GENERATE group,COUNT(data.year);

-- DUMP records_by_country;
store result into '/tmp/gini/output/records_by_country' using PigStorage(',','-schema');