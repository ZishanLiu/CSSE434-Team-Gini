-- %declare NOW 'date +%Y-%m-%d'
%declare DATETIME CurrentTime();
REGISTER 'hdfs:///tmp/wangc6/PigUDF-0.0.1-SNAPSHOT.jar';
DEFINE DIVIDE edu.rosehulman.wangc6.Divide();
DEFINE TRIM edu.rosehulman.wangc6.Trim();
records = LOAD '$input' using PigStorage(',') AS (log:chararray);
split_records = FOREACH records GENERATE STRSPLIT(log) as split_log;
cleand_records = FOREACH split_records GENERATE TRIM(split_log.$7) as name, split_log.$13 as type;
grouped_records = GROUP cleand_records BY name;
result = FOREACH grouped_records GENERATE cleand_records.name as name, DIVIDE(COUNT(type=='Hit'),COUNT*) as hit_rate, DIVIDE(COUNT(type=='Error'),COUNT*) as error_rate, 
GetYear(DATETIME) as year, GetMonth(DATETIME) as month, GetDay(DATETIME) as dat, GetHour(DATETIME) as hour;
STORE result into '$output//$DATETIME' using PigStorage('\t');


--count *
--count x-edge-result-type attribute hits
--count error 
-- divide them using udf
--get datetime
--store it to corresponding directory

-- %declare DATETIME `date +%Y-%m-%d`
-- REGISTER 'hdfs:///tmp/PigUDF-0.0.1-SNAPSHOT.jar';
-- DEFINE checkQuality edu.rosehulman.zhaiz.IsGoodQuality();
-- DEFINE TRIMFUNC edu.rosehulman.zhaiz.Trim();
-- DEFINE RATIO edu.rosehulman.zhaiz.Ratio();
-- records = LOAD '$input' using PigStorage('\t') AS (date:chararray, time:chararray, x_edge_location:chararray, sc_bytes:int, c_ip:chararray, cs_method:chararray, cs_Host:chararray,
--  cs_uri_stem:chararray, sc_status:int, cs_Referer:chararray, cs_User_Agent:chararray, cs_uri_query:chararray, cs_Cookie:chararray, x_edge_result_type:chararray, x_edge_request_id:chararray);
-- frecords = FILTER records by checkQuality(cs_uri_stem);
-- srecords = foreach frecords generate TRIMFUNC(cs_uri_stem) as name, x_edge_result_type;
-- grecords = GROUP srecords by name;
-- totalRecords = foreach grecords generate group as name, srecords as content, COUNT(srecords) as total;
-- hits = FILTER srecords by x_edge_result_type=='Hit';
-- ghits = GROUP hits by name;
-- hitRecords = foreach ghits generate group as name, hits as content, COUNT(hits) as hits;
-- TotalWithHitsRecords = JOIN totalRecords by name LEFT OUTER, hitRecords by name;
-- TotalWithHits = foreach TotalWithHitsRecords generate totalRecords::name as name, hitRecords::hits as hits, totalRecords::total as total;
-- errors = FILTER srecords by x_edge_result_type=='Error';
-- gerrors = GROUP errors by name;
-- errorRecords = foreach gerrors generate group as name, errors as content, COUNT(errors) as errors;
-- temp = JOIN TotalWithHits by name LEFT OUTER, errorRecords by name;
-- -- HitsErrotsTotal = foreach temp generate TotalWithHits::name as name, TotalWithHits::hits as hits, errorRecords::errors as errors, TotalWithHits::total as total;
-- ratios = foreach HitsErrotsTotal generate name, RATIO(hits, total) as hitRate, RATIO(errors, total) as errorRate, CurrentTime() as time;
-- out = foreach ratios generate name, hitRate, errorRate, GetYear(time) as year, GetMonth(time) as month, GetDay(time) as day, GetHour(time) as hour;
-- STORE out into '$output//$DATETIME' using PigStorage(',');
