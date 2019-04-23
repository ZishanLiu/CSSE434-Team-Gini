records = LOAD 'tempInput.txt' using PigStorage('\t') AS (year:int,temperature:int,quality:int);
frecords = FILTER records BY quality==0 or quality ==1 ;
grecords = GROUP frecords BY year;
result = FOREACH grecords GENERATE group as year, MIN(grecords.temperature) as MinTemp, MAX(grecords.temperature) as MaxTemp, AVG(grecords.temperature) as AvgTemp;
STORE result INTO '/tmp/Lab5Output' USING PigStorage(',');
DUMP result;