#!/bin/sh
player=$1

#Source secrets
. ./secrets/mysql.env

if [ $# -lt 1 ]; then 
  exit 1;
fi

sql="DELETE FROM cnr_misc WHERE player='$player';"
echo "process $sql ?"
read c
mysql --database=${DB_NAME} -u ${DB_USER} --password=${DB_PASSWORD} -e "$sql" -h ${DB_HOST}

#######
## NOT NEEDED
sql="DELETE FROM locations WHERE player='$player';"
echo "process $sql ?"
read c
mysql --database=${DB_NAME} -u ${DB_USER} --password=${DB_PASSWORD} -e "$sql" -h ${DB_HOST}

#######
## PWDATA
sql="DELETE FROM pwdata WHERE player='$player';"
echo "process $sql ?"
read c
mysql --database=${DB_NAME} -u ${DB_USER} --password=${DB_PASSWORD} -e "$sql" -h ${DB_HOST}

#######
## PWHORSES
sql="DELETE FROM pwhorses WHERE player='$player';"
echo "process $sql ?"
read c
mysql --database=${DB_NAME} -u ${DB_USER} --password=${DB_PASSWORD} -e "$sql" -h ${DB_HOST}

#######
## room_hire
sql="DELETE FROM room_hire WHERE player='$player';"
echo "process $sql ?"
read c
mysql --database=${DB_NAME} -u ${DB_USER} --password=${DB_PASSWORD} -e "$sql" -h ${DB_HOST}

###########
#### PERISTANCE
sql="SELECT 'line' as header, id, ident FROM pw_persist_containers WHERE ident LIKE '~$player|%';"
echo "process $sql ?"
read c
mysql --database=${DB_NAME} -u ${DB_USER} --password=${DB_PASSWORD} -e "$sql" -h ${DB_HOST} | while read ln
do
  echo ">> $ln"
  if `echo $ln | grep "^line" > /dev/null`
  then 
    id=`echo $ln| tr '	' ' ' | tr -s ' ' | cut -d ' ' -f 2`
    echo "#### $ln"
    echo "ID = $id"
    sql="DELETE FROM pw_persist_items WHERE container='$id';"
    echo "process $sql ?"
    read c
    mysql --database=${DB_NAME} -u ${DB_USER} --password=${DB_PASSWORD} -e "$sql" -h ${DB_HOST}
  fi
done 

#######
## Remove container
sql="DELETE FROM pw_persist_containers WHERE ident LIKE '~$player|%'"
echo "process $sql ?"
read c
mysql --database=${DB_NAME} -u ${DB_USER} --password=${DB_PASSWORD} -e "$sql" -h ${DB_HOST}



cd ~/servervault/$player
pwd
echo "REMOVE ?"
ls *.bic
read c
##########
## MAKE backup
dt=`date +%y%m%d`
tar -czvf backup${dt}.tgz *.bic

rm *.bic
ls -la

