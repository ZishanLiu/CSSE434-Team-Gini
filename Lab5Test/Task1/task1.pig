records = LOAD '$input' using PigStorage('\t') AS (year:int,temperature:int,quality:int);
frecords = FILTER records BY quality==0 or quality ==1 ;
grecords = GROUP frecords BY year;
result = FOREACH grecords GENERATE group as year, MIN(frecords.temperature) as MinTemp, MAX(frecords.temperature) as MaxTemp, AVG(frecords.temperature) as AvgTemp;
STORE result INTO '$output' USING PigStorage(',');