-- not used now
data = LOAD 'hbase://gini_index' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage(
'country:name
 country:code
 value:year
 value:value','-loadKey false') AS (country_name:chararray, country_code:chararray, year:int, value:float);

years = GROUP data by year;

records_by_year = FOREACH years GENERATE group,COUNT(data.country_code);

-- DUMP records_by_year ;
store records_by_year into '/tmp/gini/output/records_by_year' using PigStorage(',','-schema');
    