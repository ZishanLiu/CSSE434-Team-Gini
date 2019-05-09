records = LOAD 'hbase://gini_index'
        USING org.apache.pig.backend.hadoop.hbase.HBaseStorage(
        'country:name country:code value:year value:value', '-loadKey false') 
        AS (name:chararray, code:chararray, year:int, value:float);
filtered = FILTER records BY year>=$start_year and year<=$end_year;
grouped = GROUP filtered BY (name,code);
avg = foreach grouped generate group.name as name, type, AVG(filtered.value) as value, date;
sort = ORDER avg by value DESC;
final = LIMIT sort $number;
-- DUMP avg
store final into '/tmp/gini/output/avg${start_year}_limited' using PigStorage(',','-schema');