REGISTER '${jar_location}';
data = LOAD '${hbaseInput}' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage(
'country:name
 country:code
 value:year
 value:value','-loadKey false')
 AS (country_name:chararray, country_code:chararray, year:int, value:float);

STORE data INTO '${hdfsOutput}/countries' USING org.apache.pig.piggybank.storage.MultiStorage('${hdfsOutput}/countries','0', 'none', ','); 
-- 
-- REGISTER hdfs:///tmp/gini/piggybank.jar;
-- define MultiStorage 
-- data = LOAD 'hbase://gini' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage(
-- 'country:name
--  country:code
--  value:year
--  value:value','-loadKey false')
--  AS (country_name:chararray, country_code:chararray, year:int, value:float);
-- STORE data INTO '/tmp/gini/RealOutput/countries' USING org.apache.pig.piggybank.storage.MultiStorage('/tmp/gini/RealOutput/countries','0', 'none', ','); 