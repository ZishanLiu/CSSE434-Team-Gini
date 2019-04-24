REGISTER 'hdfs:///tmp/input/PigUDF-0.0.1-SNAPSHOT.jar';
DEFINE UPPER edu.rosehulman.wangc6.Upper();
records = LOAD '$input' using PigStorage() AS (sentence:chararray);
trecords = FOREACH records GENERATE flatten(TOKENIZE(UPPER(sentence))) as word;
DUMP trecords;
grecords = GROUP trecords BY word;
result = FOREACH grecords GENERATE group as Word, COUNT(trecords.word) as Count;
STORE result INTO '$output' USING PigStorage(',');