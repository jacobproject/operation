#!/bin/bash
#This Rsync script based on inotify.
#Date:2012-10-1
#Version:1.0 beta
#
export PATH=/bin:/usr/bin:/usr/local/bin
SRC=/web_data/
DEST1=web1
DEST2=web2
Client1=192.168.0.102
Client2=192.168.0.103
User=tom
#password file must not be other-accessible.
Passfile=/root/rsync.pass
[ ! -e $Passfile ] && exit 2
#Wait for change
inotifywait -mrq --timefmt '%y-%m-%d %H:%M' --format '%T %w%f %e' \ 
--event modify,create,move,delete,attrib $SRC|while read line
do
echo "$line" > /var/log/inotify_web 2>&1
/usr/bin/rsync -avz --delete --progress --password-file=$Passfile $SRC \  ${User}@$Client1::$DEST1 >>/var/log/sync_web1 2>&1
/usr/bin/rsync -avz --delete --progress --password-file=$Passfile $SRC \  ${User}@$Client2::$DEST2 >>/var/log/sync_web2 2>&1
done &
