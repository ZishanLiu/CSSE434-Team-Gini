records = LOAD 'hbase://gini_index'
        USING org.apache.pig.backend.hadoop.hbase.HBaseStorage(
        'country:name country:code value:year value:value', '-loadKey false') 
        AS (country_name:chararray, country_code:chararray, year:int, value:float);
grouped = GROUP records BY (name,code);
recent = foreach grouped {
    ordered = order gropued by year DESC;
    limited = limit ordered 1;
    genereate flatten limited;
}
DUMP recent