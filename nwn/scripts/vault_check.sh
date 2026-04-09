#!/bin/sh

. $HOME/secrets/mysql.env

tail -f logs.0/nwserverLog1.txt | while read line
#cat logs.0/nwserverLog_2010-01-27-02:01:11 | while read line
do
  if `echo $line | grep "Joined as Player" > /dev/null` 
  then
      
   clean=`echo $line | sed -e 's/\[[ :A-Za-z0-9]\+\] \(.*\) (\([A-Z0-9]\{8\}\)) Joined as Player [0-9]\+/|\1|\2|/g'`
   #echo "$line"
   login=`echo "$clean" | cut -d '|' -f 2`
   key=`echo "$clean" | cut -d '|' -f 3`
#   echo $login
#   echo $key
   sql="SELECT cdkey from pwplayers where login='$login';"
   ret=`mysql --database=${DB_NAME} -u ${DB_USER} --password=${DB_PASSWORD} -e "$sql" -h ${DB_HOST} | tail -n 1`
#   echo "$ret"
   echo $login
   if [ "$login" != "Brantenen" ]
   then
     continue;
   fi
   if [ "$key" = "$ret" ] 
   then
     echo $login
     echo "PASS"
     cd "$HOME/servervault/"
     echo "chmod ugo+rx $login"
     chmod ugo+rx "$login"
   else 
     echo "FAILED!!!!!!!!!!!!!!!"
     cd "$HOME/servervault/"
     echo "chmod ugo-rx $login"
     chmod ugo-rx "$login"
   fi
  fi 
done
