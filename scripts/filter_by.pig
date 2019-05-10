raw = LOAD 'hbase://gini_index'
	USING org.apache.pig.backend.hadoop.hbase.HBaseStorage('country:name country:code value:year value:value', '-loadKey false') AS (country_name:chararray, country_code:chararray, year:int, value:float);
filtered_gini_index = FILTER raw by $by == $value;
DUMP filtered_gini_index;
