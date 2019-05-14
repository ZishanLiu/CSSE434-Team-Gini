CREATE DATABASE IF NOT EXISTS ${hivevar:logAnalysisusername};
USE ${hivevar:logAnalysisusername};

CREATE TABLE IF NOT EXISTS archiveLogData(name string,hitRate float,errorRate float,year int,month int,day int,hour int) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE;
LOAD DATA INPATH '${hivevar:pigOutputDir}/${hivevar:jobDate}' OVERWRITE INTO TABLE archiveLogData;
