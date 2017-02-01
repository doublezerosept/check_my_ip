# check_my_ip

Script to run from cron to check if current public IP changed.  If it did, it sends an email to a defined recipient

Configure some variables in the check_ip.conf file.

This script uses ssmtp so make sure /etc/ssmtp/ssmtp.conf is properly configured with proper settings.  For example:
```
mailhub=smtp.gmail.com:465
rewriteDomain=<domain>
AuthUser=<user>
AuthPass=<pass>
hostname=<hostname>
FromLineOverride=YES
UseTLS=YES
```
