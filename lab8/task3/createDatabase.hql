CREATE DATABASE IF NOT EXISTS ${databaseName};
USE ${databaseName};

CREATE TABLE IF NOT EXISTS ${tableName}(name string,hitRate float,errorRate float,year int,month int,day int,hour int) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE;
LOAD DATA INPATH '${pigOutputDir}/${jobDate}' OVERWRITE INTO TABLE ${tableName};
