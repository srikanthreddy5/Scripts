#!/bin/bash
# This will get event count from listener box  source files and SHC.
# It will send email with table with event count.

echo "Running script for eventcount"

> e_count.csv
# This script is to compare events from listener box and eventount from SH query
bygone=`date  --date="yesterday" +"%Y-%m-%d"`

#echo "P2ProdCA event_count for each index for date: $bygone "  >> e_count.csv
echo "Index_Name","EventCount_from_source_files","EventCount_Search_Head"  >> e_count.csv
for dir in  /P2/log/cerner_??????/processed/archive;
do
  #echo "printing first $dir"

  client_name=`echo $dir | cut -d '/' -f 4 | cut -d '_' -f 2`

  export p2_source=$dir
  for FILE in $(find  $dir -type f -name "processed.log_${bygone}*");
  do

    if [[ $FILE =~ .gz ]];
    then
      count=$(zcat $FILE | wc -l)
    else
      count=$(cat $FILE | wc -l)
    fi
    #echo $count
    let total=$(( $total + $count ))
    Eventcount_from_source_files=$total
  done
  #echo "Event count from Listener:"  $total
  total=0
  query="index=*_cerner_millennium source=${p2_source}/processed.log_${bygone}*.log host="cernsnlcalis201.cerncd.com"  earliest=-1d@d | stats count"
  event_count=$(/opt/splunk/bin/splunk search "$query" -uri 'https://p2sentinel.ca.p2splunk.net:8089/' -auth p2s-script:splunk123 2>/dev/null)
  #echo $event_count
  event_count=`echo $event_count | awk '{print $3}'`
  #echo "Event count from SH query $event_count"

  echo "${client_name}_cerner_millennium" , "$Eventcount_from_source_files", "$event_count" >> e_count.csv
  Eventcount_from_source_files=0
done

echo "running scp to get csv cernsnlcalis202"
scp root@cernsnlcalis202.cerncd.com:/opt/scripts/e_count_202.csv /opt/scripts/

echo "Running python for sending email"
python3 /opt/scripts/sendpanda.py
