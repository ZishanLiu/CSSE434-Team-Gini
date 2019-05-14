%declare DATETIME `date +%Y-%m-%d`
REGISTER 'hdfs:///tmp/wangc6/PigUDF-0.0.1-SNAPSHOT.jar';
DEFINE DIVIDE edu.rosehulman.wangc6.Divide();
DEFINE TRIM edu.rosehulman.wangc6.Trim();
DEFINE CHECKBLOG edu.rosehulman.wangc6.CheckBlog();
records = LOAD '$input' using PigStorage(',') AS (log:chararray);
split_records = FOREACH records GENERATE STRSPLIT(log) as split_log;
truncated_records = FOREACH split_records GENERATE split_log.$7 as name, split_log.$13 as type;
valid_records = FILTER truncated_records by CHECKBLOG(name);
cleaned_records = FOREACH valid_records generate TRIM(name) as name, type;
grouped_records = GROUP cleaned_records BY name;
total_count = FOREACH grouped_records GENERATE group as name, COUNT(cleaned_records) as total;
hit_records = FILTER cleaned_records by type == 'Hit';
grouped_hit = group hit_records by name;
hit_count = FOREACH grouped_hit GENERATE group as name, COUNT(hit_records.type) as hits;
join_hit_records = JOIN total_count by name LEFT OUTER, hit_count by name;
error_records = FILTER cleaned_records by type == 'Error';
grouped_error = group error_records by name;
error_count = FOREACH grouped_error GENERATE group as name, COUNT(error_records.type) as errors;
join_both_records = JOIN join_hit_records by total_count::name LEFT OUTER, error_count by name;
result = FOREACH join_both_records GENERATE total_count::name as name, DIVIDE(hits,total) as hit_rate, DIVIDE(errors,total) as error_rate,
GetYear(CurrentTime()) as year, GetMonth(CurrentTime()) as month, GetDay(CurrentTime()) as date, GetHour(CurrentTime()) as hour;
dump result;
STORE result into '$output/$DATETIME/' using PigStorage('\t');