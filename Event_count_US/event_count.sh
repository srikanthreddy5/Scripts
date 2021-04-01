#!/bin/bash
# This will get event count from listener box  source files and SHC.
# It will send email with table with event count.
# searches all the folders starter with cern in /P2/log  gets the eventcount for source_files name with yesterday's date
#  Make cli search for SHC to get event for yetserday

echo "Running script for eventcount"

SHC_URL=$1
#domain=$2

if [ -z $SHC_URL ]; then printf "\nERROR: The URL is a required attribute for : Sample url is https://p2sentinel.ca.p2splunk.net:8089/."; exit 1; fi

> /opt/scripts/e_count.csv
eventcount_from_source_files=0

# This script is to compare events from listener box and eventount from SH query
export bygone=`date  --date="yesterday" +"%Y-%m-%d"`

search_cern_comc () {
  query="| tstats count where  index=9984-* source=$1/processed.log_${bygone}*.log host=`hostname -f`  earliest=-3d@d "
  event_count=$(sudo -u splunk /opt/splunk/bin/splunk search "$query" -uri $2 -auth p2s-script:splunk123 2>/dev/null)
  #echo $event_count
  shc_event_count=`echo $event_count | awk '{print $3}'`
  return $shc_event_count
}

search_cern_comd () {
  query="| tstats count where  index=9875-* source=$1/processed.log_${bygone}*.log host=`hostname -f`  earliest=-3d@d "
  event_count=$(sudo -u splunk /opt/splunk/bin/splunk search "$query" -uri $2 -auth p2s-script:splunk123 2>/dev/null)
  #echo $event_count
  shc_event_count=`echo $event_count | awk '{print $3}'`
  return $shc_event_count
}

search_cern_comf () {
  query="| tstats count where  index=0581-* source=$1/processed.log_${bygone}*.log host=`hostname -f`  earliest=-3d@d "
  event_count=$(sudo -u splunk /opt/splunk/bin/splunk search "$query" -uri $2 -auth p2s-script:splunk123 2>/dev/null)
  #echo $event_count
  shc_event_count=`echo $event_count | awk '{print $3}'`
  return $shc_event_count
}

search_cern_comg () {
  query="| tstats count where  index=0602-* source=$1/processed.log_${bygone}*.log host=`hostname -f`  earliest=-3d@d "
  event_count=$(sudo -u splunk /opt/splunk/bin/splunk search "$query" -uri $2 -auth p2s-script:splunk123 2>/dev/null)
  #echo $event_count
  shc_event_count=`echo $event_count | awk '{print $3}'`
  return $shc_event_count
}

search_cern_comh () {
  query="| tstats count where  index=0786-* source=$1/processed.log_${bygone}*.log host=`hostname -f`  earliest=-3d@d "
  event_count=$(sudo -u splunk /opt/splunk/bin/splunk search "$query" -uri $2 -auth p2s-script:splunk123 2>/dev/null)
  #echo $event_count
  shc_event_count=`echo $event_count | awk '{print $3}'`
  return $shc_event_count
}

search_cern_comi () {
  query="| tstats count where  index=1848-* source=$1/processed.log_${bygone}*.log host=`hostname -f`  earliest=-3d@d "
  event_count=$(sudo -u splunk /opt/splunk/bin/splunk search "$query" -uri $2 -auth p2s-script:splunk123 2>/dev/null)
  #echo $event_count
  shc_event_count=`echo $event_count | awk '{print $3}'`
  return $shc_event_count
}

search_cern_como () {
  query="| tstats count where  index=0440-* source=$1/processed.log_${bygone}*.log host=`hostname -f`  earliest=-3d@d "
  event_count=$(sudo -u splunk /opt/splunk/bin/splunk search "$query" -uri $2 -auth p2s-script:splunk123 2>/dev/null)
  #echo $event_count
  shc_event_count=`echo $event_count | awk '{print $3}'`
  return $shc_event_count
}

search_cern_empl () {
  query="| tstats count where  index=9900-* source=$1/processed.log_${bygone}*.log host=`hostname -f`  earliest=-3d@d "
  event_count=$(sudo -u splunk /opt/splunk/bin/splunk search "$query" -uri $2 -auth p2s-script:splunk123 2>/dev/null)
  #echo $event_count
  shc_event_count=`echo $event_count | awk '{print $3}'`
  return $shc_event_count
}

search_cern_hec () {
  query="| tstats count where  index=9912-* source=$1/processed.log_${bygone}*.log host=`hostname -f`  earliest=-3d@d "
  event_count=$(sudo -u splunk /opt/splunk/bin/splunk search "$query" -uri $2 -auth p2s-script:splunk123 2>/dev/null)
  #echo $event_count
  shc_event_count=`echo $event_count | awk '{print $3}'`
  return $shc_event_count
}

search_cern_ltca () {
  query="| tstats count where  index=289-* source=$1/processed.log_${bygone}*.log host=`hostname -f`  earliest=-3d@d "
  event_count=$(sudo -u splunk /opt/splunk/bin/splunk search "$query" -uri $2 -auth p2s-script:splunk123 2>/dev/null)
  #echo $event_count
  shc_event_count=`echo $event_count | awk '{print $3}'`
  return $shc_event_count
}

search_cern_ph () {
  query="| tstats count where index=0501-* source=$1/processed.log_${bygone}*.log host=`hostname -f`  earliest=-3d@d "
  event_count=$(sudo -u splunk /opt/splunk/bin/splunk search "$query" -uri $2 -auth p2s-script:splunk123 2>/dev/null)
  #echo $event_count
  shc_event_count=`echo $event_count | awk '{print $3}'`
  return $shc_event_count
}

search_cphy_pr () {
  query="| tstats count where  index=4298-* source=$1/processed.log_${bygone}*.log host=`hostname -f`  earliest=-3d@d "
  event_count=$(sudo -u splunk /opt/splunk/bin/splunk search "$query" -uri $2 -auth p2s-script:splunk123 2>/dev/null)
  #echo $event_count
  shc_event_count=`echo $event_count | awk '{print $3}'`
  return $shc_event_count
}

search_cphyb_pr () {
  query="| tstats count where  index=4298b-* source=$1/processed.log_${bygone}*.log host=`hostname -f`  earliest=-3d@d "
  event_count=$(sudo -u splunk /opt/splunk/bin/splunk search "$query" -uri $2 -auth p2s-script:splunk123 2>/dev/null)
  #echo $event_count
  shc_event_count=`echo $event_count | awk '{print $3}'`
  return $shc_event_count
}

search_cphyc_pr () {
  query="| tstats count where  index=4300-* source=$1/processed.log_${bygone}*.log host=`hostname -f`  earliest=-3d@d "
  event_count=$(sudo -u splunk /opt/splunk/bin/splunk search "$query" -uri $2 -auth p2s-script:splunk123 2>/dev/null)
  #echo $event_count
  shc_event_count=`echo $event_count | awk '{print $3}'`
  return $shc_event_count
}

search_cvha_ks () {
  query="| tstats count where  index=101-* source=$1/processed.log_${bygone}*.log host=`hostname -f`  earliest=-3d@d "
  event_count=$(sudo -u splunk /opt/splunk/bin/splunk search "$query" -uri $2 -auth p2s-script:splunk123 2>/dev/null)
  #echo $event_count
  shc_event_count=`echo $event_count | awk '{print $3}'`
  return $shc_event_count
}

search_cerner_sh(){
  query="| tstats count where index=*_cerner_millennium source=$1/processed.log_${bygone}*.log host=`hostname -f`  earliest=-3d@d "
  event_count=$(/opt/splunk/bin/splunk search "$query" -uri $2 -auth p2s-script:splunk123 2>/dev/null)
#echo $event_count
  shc_event_count=`echo $event_count | awk '{print $3}'`
  echo "Event count from SH query $shc_event_count"
  return $shc_event_count
}


echo "Client_Name","EventCount_from_Source_Files","EventCount_Search_Head"  >> /opt/scripts/e_count.csv

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
  echo "Event count from Listener:"  $total
  total=0

########## Call Rest search

  if [[ $client_name == "cern_comc" ]];
  then
    search_cern_comc $p2_source $SHC_URL
    echo "Event count from SHC:"  $shc_event_count
  elif [[ $client_name == "cern_comd" ]];
  then
    search_cern_comd $p2_source $SHC_URL
    echo "Event count from SHC:"  $shc_event_count
  elif [[ $client_name == "cern_comf" ]];
  then
    search_cern_comf $p2_source $SHC_URL
    echo "Event count from SHC:"  $shc_event_count
  elif [[ $client_name == "cern_comg" ]];
  then
    search_cern_comg $p2_source $SHC_URL
    echo "Event count from SHC:"  $shc_event_count
  elif [[ $client_name == "cern_comh" ]];
  then
    search_cern_comh $p2_source $SHC_URL
    echo "Event count from SHC:"  $shc_event_count
  elif [[ $client_name == "cern_comi" ]];
  then
    search_cern_comi $p2_source $SHC_URL
    echo "Event count from SHC:"  $shc_event_count
  elif [[ $client_name == "cern_como" ]];
  then
    search_cern_como $p2_source $SHC_URL
    echo "Event count from SHC:"  $shc_event_count
  elif [[ $client_name == "cern_empl" ]];
  then
    search_cern_empl $p2_source $SHC_URL
    echo "Event count from SHC:"  $shc_event_count
  elif [[ $client_name == "cern_hec" ]];
  then
    search_cern_hec $p2_source $SHC_URL
    echo "Event count from SHC:"  $shc_event_count
  elif [[ $client_name == "cern_ltca" ]];
  then
    search_cern_ltca $p2_source $SHC_URL
    echo "Event count from SHC:"  $shc_event_count
  elif [[ $client_name == "cern_ph" ]];
  then
    search_cern_ph $p2_source $SHC_URL
    echo "Event count from SHC:"  $shc_event_count
  elif [[ $client_name == "cphy_pr" ]];
  then
    search_cphy_pr $p2_source $SHC_URL
    echo "Event count from SHC:"  $shc_event_count
  elif [[ $client_name == "cphyb_pr" ]];
  then
    search_cphyb_pr $p2_source $SHC_URL
    echo "Event count from SHC:"  $shc_event_count
  elif [[ $client_name == "cphyc_pr" ]];
  then
    search_cphyc_pr $p2_source $SHC_URL
    echo "Event count from SHC:"  $shc_event_count
  elif [[ $client_name == "cvha_ks" ]];
  then
    search_cvha_ks $p2_source $SHC_URL
    echo "Event count from SHC:"  $shc_event_count
  else
    echo "Running for cerner_name"
    echo "search_cerner_sh $p2_source $SHC_URL"
  fi
####
  echo "${client_name}_cerner_millennium" , "$eventcount_from_source_files", "$shc_event_count" >> /opt/scripts/e_count.csv
  eventcount_from_source_files=0
  shc_event_count=0
  event_count=0
done

python3 /opt/scripts/send_email.py
