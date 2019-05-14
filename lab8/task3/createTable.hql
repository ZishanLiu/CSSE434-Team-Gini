USE ${databaseName};
Create TABLE IF NOT EXISTS ${tableName2}(name string,hitRate float,errorRate float) PARTITIONED BY (year int, month int, day int, hour int) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS ORC;
insert into table ${tableName2} PARTITION(year, month, day, hour) select name, hitRate, errorRate, year, month, day, hour from  ${tableName};

-- Create TABLE IF NOT EXISTS logData2(name string,hitRate float,errorRate float) PARTITIONED BY (year int, month int, day int, hour int) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS ORC;
-- insert into table logData2 PARTITION(year, month, day, hour) select name, hitRate, errorRate, year, month, day, hour from  logdata;

 