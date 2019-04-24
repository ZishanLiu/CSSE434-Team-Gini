records = LOAD '$input' using PigStorage() AS sentence;
trecords = FOREACH records GENERATE flatten(TOKENIZE(sentence)) as word;
DUMP trecords;
-- grecords = GROUP frecords BY year;
-- result = FOREACH grecords GENERATE group as year, MIN(frecords.temperature) as MinTemp, MAX(frecords.temperature) as MaxTemp, AVG(frecords.temperature) as AvgTemp;
-- STORE result INTO '$output' USING PigStorage(',');