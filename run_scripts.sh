#!/bin/bash          
 
# $1 = hbase input hbase://gini
# $2 = hdfs output /tmp/gini/RealOutput
# $3 = local output RealOutput

# rm -rf $3
# mkdir $3
hadoop fs -rm -r $2;
hadoop fs -mkdir $2;


start=1980
num=10
while [ $start -le 2015 ]
do
    end=$((start + 4))
    echo $start 
    echo $end
    pig -x mapreduce -p start_year=${start} -p end_year=${end} -p number=${num} -p hbaseInput=$1 -p hdfsOutput=$2 scripts/highest_between.pig;
    hadoop fs -rm "${2}/${start}_${end}top${num}/.pig_schema"
    hadoop fs -getmerge "${2}/${start}_${end}top${num}" "${3}/${start}_${end}top${num}.csv"
    pig -x mapreduce -p start_year=${start} -p end_year=${end} -p number=${num} -p hbaseInput=$1 -p hdfsOutput=$2 scripts/lowest_between.pig;
    hadoop fs -rm "${2}/${start}_${end}low${num}/.pig_schema"
    hadoop fs -getmerge "${2}/${start}_${end}low${num}" "${3}/${start}_${end}low${num}.csv"
    start=$((start + 5))
done

head -1 1980*top*.csv > top.csv
for filename in $(ls *top*.csv); do sed 1d $filename >> top.csv; done
head -1 1980*low*.csv > low.csv
for filename in $(ls *low*.csv); do sed 1d $filename >> low.csv; done

pig -x mapreduce -p hbaseInput=$1 -p hdfsOutput=$2 scripts/recent.pig
hadoop fs -rm "${2}/recent/.pig_schema"
hadoop fs -getmerge "${2}/recent" "${3}/recent.csv"

pig -x mapreduce -p hbaseInput=$1 -p hdfsOutput=$2 scripts/count_records_by_year.pig
hadoop fs -rm "${2}/records_by_year/.pig_schema" 
hadoop fs -getmerge "${2}/records_by_year" "${3}/records_by_year.csv"

pig -x mapreduce -p hbaseInput=$1 -p hdfsOutput=$2 -p jar_location=hdfs:///tmp/gini/piggybank-0.15.0.jar scripts/split_countries.pig
hadoop fs -get "${2}/countries" "${3}/countries"
cd ${3}/countries
for file in */*000; do mv "$file" "${file/-0,000/.csv}" ; done
mv */*.csv .
rm -rf */
rm -f _SUCCESS
echo "NAME,CODE,YEAR,VALUE" > headerfile
for csv in *.csv; do cat headerfile "$csv" > tmpfile2; mv -f tmpfile2 "$csv"; done
rm -f headerfile

# below are not used for now

# pig -x mapreduce -p hbaseInput=hbase://gini_index -p hdfsOutput=/tmp/gini/output scripts/count_records_by_country.pig
# hadoop fs -rm /tmp/gini/output/records_by_country/.pig_schema
# hadoop fs -getmerge /tmp/gini/output/records_by_country output/records_by_country.csv

# pig -x mapreduce -p hbaseInput=$1 -p hdfsOutput=$2 -p start_year=2010 -p end_year=2019 scripts/avg_period.pig
# hadoop fs -rm /tmp/gini/output/avg2010/.pig_schema
# hadoop fs -getmerge /tmp/gini/output/avg2010 output/avg2010.csv