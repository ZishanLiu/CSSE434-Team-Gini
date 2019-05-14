%declare DATETIME `date +%Y-%m-%d`
REGISTER 'hdfs:///tmp/input/task4.jar';
DEFINE DIVIDE edu.rosehulman.liuz6.Divide();
DEFINE TRIM edu.rosehulman.liuz6.Trim();
DEFINE CHECK edu.rosehulman.liuz6.Check();

records = LOAD '$INPUT' using PigStorage(',') AS (log:chararray);
split_input = FOREACH records GENERATE STRSPLIT(log) as log;

info = FOREACH split_input GENERATE log.$7 as name, log.$13 as type;
checked_records = FILTER info by CHECK(name);
cleaned_records = FOREACH checked_records generate TRIM(name) as name, type;
group_records = GROUP cleaned_records BY name;

hit_records = FILTER cleaned_records by type == 'Hit';
count = FOREACH group_records GENERATE group as name, COUNT(cleaned_records) as total;
grouped_hit = group hit_records by name;
hit_count = FOREACH grouped_hit GENERATE group as name, COUNT(hit_records.type) as hits;
joined_hit = JOIN count by name LEFT OUTER, hit_count by name;

error = FILTER cleaned_records by type == 'Error';
group_error = group error by name;
error_count = FOREACH group_error GENERATE group as name, COUNT(error.type) as errors;

both_records = JOIN joined_hit by count::name LEFT OUTER, error_count by name;

result = FOREACH both_records GENERATE count::name as name, DIVIDE(hits,total) as rate, DIVIDE(errors,total) as error_rate,
GetYear(CurrentTime()) as year, GetMonth(CurrentTime()) as month, GetDay(CurrentTime()) as date, GetHour(CurrentTime()) as hour;
STORE result into '$OUTPUT//$DATETIME' using PigStorage('\t');
