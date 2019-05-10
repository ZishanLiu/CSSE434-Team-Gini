records = LOAD '${hbaseInput}'
        USING org.apache.pig.backend.hadoop.hbase.HBaseStorage(
        'country:name country:code value:year value:value', '-loadKey false') 
        AS (name:chararray, code:chararray, year:int, value:float);
grouped = GROUP records BY (name,code);
recent = foreach grouped {
    ordered = order records by year DESC;
    limited = limit ordered 1;
    generate flatten(limited);
}
result = foreach recent generate name as country, value as value;
store result into '${hdfsOutput}/recent' using PigStorage(',','-schema');
-- 
-- records = LOAD 'hbase://gini_index'
--         USING org.apache.pig.backend.hadoop.hbase.HBaseStorage(
--         'country:name country:code value:year value:value', '-loadKey false') 
--         AS (name:chararray, code:chararray, year:int, value:float);
-- grouped = GROUP records BY (name,code);
-- recent = foreach grouped {
--     ordered = order records by year DESC;
--     limited = limit ordered 1;
--     generate flatten(limited);
-- }
-- result = foreach recent generate name as country, value as value;
-- store result into '/tmp/gini/output/recent' using PigStorage(',','-schema');
