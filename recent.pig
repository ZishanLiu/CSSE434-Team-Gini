records = LOAD 'hbase://gini_index'
        USING org.apache.pig.backend.hadoop.hbase.HBaseStorage(
        'country:name country:code value:year value:value', '-loadKey false') 
        AS (name:chararray, code:chararray, year:int, value:float);
grouped = GROUP records BY (name,code);
recent = foreach grouped {
    ordered = order grouped by year DESC;
    limited = limit ordered 1;
    generate flatten(limited);
}
DUMP recent;