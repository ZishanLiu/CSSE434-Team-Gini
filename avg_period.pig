records = LOAD 'hbase://gini_index'
        USING org.apache.pig.backend.hadoop.hbase.HBaseStorage(
        'country:name country:code value:year value:value', '-loadKey false') 
        AS (country_name:chararray, country_code:chararray, year:int, value:float);
filtered = FILTER records BY year>$start_year && year<$end_year;
grouped = GROUP filtered BY (name,code);
avg = foreach grouped generate group.name as name, AVG(filtered.value) as average;
DUMP avg