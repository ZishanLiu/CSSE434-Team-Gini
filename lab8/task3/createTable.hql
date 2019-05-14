
Create TABLE IF NOT EXISTS ${hivevar:tableName2}(name string,hitRate float,errorRate float) PARTITIONED BY (year int, month int, day int, hour int) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS ORC;

insert into table ${hivevar:tableName2} PARTITION(year=${hivevar:year}, month=${hivevar:month}, day=${hivevar:day}, hour=${hivevar:hour}) select name, hitRate, errorRate from  ${hivevar:tableName} where year=${hivevar:year} and month=${hivevar:month} and day=${hivevar:day} and hour=${hivevar:hour};

 