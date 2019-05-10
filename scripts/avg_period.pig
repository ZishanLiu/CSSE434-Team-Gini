-- not used now
records = LOAD '${hbaseInput}'
        USING org.apache.pig.backend.hadoop.hbase.HBaseStorage(
        'country:name country:code value:year value:value', '-loadKey false') 
        AS (name:chararray, code:chararray, year:int, value:float);
filtered = FILTER records BY year>=$start_year and year<=$end_year;
grouped = GROUP filtered BY (name,code);
avg = foreach grouped generate group.name as name, AVG(filtered.value) as average;
store avg into '${hdfsOutput}/avg${start_year}' using PigStorage(',','-schema');
-- 
-- records = LOAD 'hbase://gini_index'
--         USING org.apache.pig.backend.hadoop.hbase.HBaseStorage(
--         'country:name country:code value:year value:value', '-loadKey false') 
--         AS (name:chararray, code:chararray, year:int, value:float);
-- filtered = FILTER records BY year>=$start_year and year<=$end_year;
-- grouped = GROUP filtered BY (name,code);
-- avg = foreach grouped generate group.name as name, AVG(filtered.value) as average;
-- store avg into '/tmp/gini/output/avg${start_year}' using PigStorage(',','-schema');