USE ${hivevar:databaseName};
Create TABLE IF NOT EXISTS ${hivevar:tableName2}(name string,hitRate float,errorRate float) PARTITIONED BY (year int, month int, day int, hour int) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS ORC;

insert into table ${hivevar:tableName2} PARTITION(year, month, day, hour) select name, hitRate, errorRate, year, month, day, hour from  ${hivevar:tableName};

 