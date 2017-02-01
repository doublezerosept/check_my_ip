#!/bin/bash

#Source the config file
CONFIG="./check_ip.conf"
. $CONFIG

#What was the IP before?
old_ip=`/usr/bin/tail -1 $IPFILE`

#What is the IP now?
new_ip=`/usr/bin/dig +short myip.opendns.com @resolver1.opendns.com`

function alert_mail {
  new_ip=$1
  old_ip=$2
  TO=$TO
  FROM=$FROM
  SUB="MY IP CHANGED TO $new_ip"

  /bin/cat <<EOT | /usr/sbin/ssmtp $TO
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
  /bin/echo "`/bin/date` : Same IP, doing nothing..." >> $LOGFILE
else
  #Add new IP to current_ip file
  /bin/echo $new_ip >> $IPFILE
  #Send email
  /bin/echo "`/bin/date` : DIFFERENT! From $old_ip to $new_ip: Sending mail..." >> $LOGFILE
  alert_mail $new_ip $old_ip
fi
