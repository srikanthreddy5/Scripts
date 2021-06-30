#!/bin/bash
# This will get event count from listener box  source files and SHC.
# It will send email with table with event count.
# searches all the folders starter with cern in /P2/log  gets the eventcount for source_files name with yesterday's date
#  Make cli search for SHC to get event for yetserday

echo "Running script for eventcount"

SHC_URL=$1
#domain=$2

splunk_pass=`echo  'xxxxxxxxx' | base64 --decode`

if [ -z $SHC_URL ]; then printf "\nERROR: The URL is a required attribute for : Sample url is https://xxxxxxxxxxxx.ca.p2splunk.net:8089/."; exit 1; fi

> /opt/scripts/e_count.csv
eventcount_from_source_files=0

# This script is to compare events from listener box and eventount from SH query
export bygone=`date  --date="yesterday" +"%Y-%m-%d"`

search_cern () {
  query="| tstats count where  index=$3-* source=$1/processed.log_${bygone}*.log host=`hostname -f`  earliest=-3d@d "
  event_count=$(sudo -u splunk /opt/splunk/bin/splunk search "$query" -uri $2 -auth p2s-script:${splunk_pass} 2>/dev/null)
  #echo $event_count
  shc_event_count=`echo $event_count | awk '{print $3}'`
  return $shc_event_count
}

# This function to called for /P2/log/cerner_xxxxx

search_cerner_sh(){
  query="| tstats count where index=$3_cerner_millennium source=$1/processed.log_${bygone}*.log host=`hostname -f`  earliest=-3d@d "
  event_count=$(sudo -u splunk /opt/splunk/bin/splunk search "$query" -uri $2 -auth p2s-script:${splunk_pass} 2>/dev/null)
  #echo $event_count
  shc_event_count=`echo $event_count | awk '{print $3}'`
  #echo "Event count from SH query $shc_event_count"
  return $shc_event_count
}

#echo "Client_Name","EventCount_from_Source_Files","EventCount_Search_Head"  >> /opt/scripts/e_count.csv

#for dir in  /P2/log/cerner_??????/processed/archive;
for dir in  $(find /P2/log/  -type d  | grep -P  "c.*?_(?<=)[a-z]+"/processed/archive | grep -v np);
do
  echo "printing first $dir"

  client_name=`echo $dir | cut -d '/' -f 4 `

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
    eventcount_from_source_files=$total
  done
  echo "Event count from source files on Listener:"  $total
  total=0

  CLIENT_LIST=( "cern_comc:9984"
                "cern_comd:9875"
                "cern_comf:0581"
                "cern_comg:0602"
                "cern_comh:0786"
                "cern_comi:1848"
                "cern_como:0440"
                "cern_empl:9900"
                "cern_hec:9912"
                "cern_ltca:289"
                "cern_ph:0501"
                "cphy_pr:4298"
                "cphyb_pr:4298b"
                "cphyc_pr:4300"
                "cvha_ks:101"             
                )

########## Call Rest search
  for client in  "${CLIENT_LIST[@]}"  ; do 
      if [[ $client_name == "${client%%:*}" ]];
      then
        search_cern $p2_source $SHC_URL "${client##*:}"
        echo "Event count from SHC:"  $client_name  $shc_event_count
      fi      
  done
  if [[ $client_name =~ cerner_[a-z]+  ]];
  then
    client=`echo $client_name | cut -d '_' -f 2 ` 
    search_cerner_sh $p2_source $SHC_URL $client
    
    client_name=$client
    echo "Event count from SHC:"  $client_name  $shc_event_count 
    
  fi   
####
  if [[ $eventcount_from_source_files != $shc_event_count ]] ; 
  then
    echo "Client_Name","EventCount_from_Source_Files","EventCount_Search_Head"  >> /opt/scripts/e_count.csv
    echo "${client_name}_cerner_millennium" , "$eventcount_from_source_files", "$shc_event_count" >> /opt/scripts/e_count.csv
  fi
  eventcount_from_source_files=0
  shc_event_count=0
  event_count=0
done

csv_file="/opt/scripts/e_count.csv"


if [ -s "csv_file" ] 
then
  echo "Calling send_email.py."
  python /opt/scripts/send_email.py  
fi
