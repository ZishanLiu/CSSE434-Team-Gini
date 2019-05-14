CREATE DATABASE IF NOT EXISTS ${hivevar:logAnalysisusername};
USE ${hivevar:logAnalysisusername};

CREATE TABLE IF NOT EXISTS archiveLogData(name string,hitRate float,errorRate float,year int,month int,day int,hour int) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE;
LOAD DATA INPATH '${hivevar:pigOutputDir}/${hivevar:jobDate}' OVERWRITE INTO TABLE archiveLogData;

Create TABLE IF NOT EXISTS logData(name string,hitRate float,errorRate float) PARTITIONED BY (year int, month int, day int, hour int) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS ORC;

insert into table logData PARTITION(year=${hivevar:year}, month=${hivevar:month}, day=${hivevar:day}, hour=${hivevar:hour}) select name, hitRate, errorRate from archiveLogData where year=${hivevar:year} and month=${hivevar:month} and day=${hivevar:day} and hour=${hivevar:hour};

 