#!/bin/bash

#Source the config file
CONFIG="./check_my_ip.conf"
source $CONFIG

#What was the IP before?
old_ip=`tail -1 $ip_file`

#What is the IP now?
new_ip=`dig +short myip.opendns.com @resolver1.opendns.com`

function alert_mail {
  new_ip=$1
  old_ip=$2
  TO=$TO
  FROM=$FROM
  SUB="MY IP CHANGED TO $new_ip"

  cat <<EOT | ssmtp $TO
To: $TO
From: $FROM
Subject: $SUB

This was the old IP: $old_ip
This is the new IP: $new_ip

-me
EOT
}

## MAIN ##
#
if [ $old_ip == $new_ip ]; then
  # Just log it, do nothing 
  echo "`date` : Same IP, doing nothing..." >> $LOGFILE
else
  #Add new IP to current_ip file
  echo $new_ip >> $IPFILE
  #Send email
  echo "`date` : DIFFERENT! From $old_ip to $new_ip: Sending mail..." >> $LOGFILE
  alert_mail $new_ip $old_ip
fi
