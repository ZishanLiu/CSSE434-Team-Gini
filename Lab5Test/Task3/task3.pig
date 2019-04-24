REGISTER 'hdfs:///tmp/wangc6/PigUDF-0.0.1-SNAPSHOT.jar';
-- REGISTER 'Task2/PigUDF-0.0.1-SNAPSHOT.jar';
DEFINE CHECKQUALITY edu.rosehulman.wangc6.IsGoodQuality();
records = LOAD '$input' using PigStorage('\t') AS (year:int,temperature:int,quality:int);
frecords = FILTER records BY CHECKQUALITY(quality);
grecords = GROUP frecords BY year;
result = FOREACH grecords GENERATE group as year, MIN(frecords.temperature) as MinTemp, MAX(frecords.temperature) as MaxTemp, AVG(frecords.temperature) as AvgTemp;
STORE result INTO '$output' USING PigStorage(',');