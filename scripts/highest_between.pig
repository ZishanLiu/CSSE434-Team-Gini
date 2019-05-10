records = LOAD '${hbaseInput}'
        USING org.apache.pig.backend.hadoop.hbase.HBaseStorage(
        'country:name country:code value:year value:value', '-loadKey false') 
        AS (name:chararray, code:chararray, year:int, value:float);
filtered = FILTER records BY year>=$start_year and year<=$end_year;
grouped = GROUP filtered BY (name,code);
avg = foreach grouped generate group.name as name, '0' as type, AVG(filtered.value) as value, '01/01/${start_year}' as date;
sort = ORDER avg by value DESC;
final = LIMIT sort $number;
store final into '${hdfsOutput}/${start_year}_${end_year}top${number}' using PigStorage(',','-schema');
-- 
-- records = LOAD 'hbase://gini_index'
--         USING org.apache.pig.backend.hadoop.hbase.HBaseStorage(
--         'country:name country:code value:year value:value', '-loadKey false') 
--         AS (name:chararray, code:chararray, year:int, value:float);
-- filtered = FILTER records BY year>=$start_year and year<=$end_year;
-- grouped = GROUP filtered BY (name,code);
-- avg = foreach grouped generate group.name as name, '0' as type, AVG(filtered.value) as value, '01/01/${start_year}' as date;
-- sort = ORDER avg by value DESC;
-- final = LIMIT sort $number;
-- store final into '/tmp/gini/output/avg${start_year}_limited' using PigStorage(',','-schema');