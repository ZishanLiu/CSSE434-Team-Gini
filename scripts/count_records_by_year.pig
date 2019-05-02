data = LOAD 'hbase://gini_index' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage(
'country:name
 country:code
 value:year
 value:value','-loadKey false') AS (country_name:chararray, country_code:chararray, year:int, value:float);

years = GROUP data by year;

countries_by_year = FOREACH years GENERATE group,COUNT(data.country_code);

-- DUMP countries_by_year ;
store countries_by_year into '/tmp/gini/output/countries_by_year' using PigStorage(',','-schema');
