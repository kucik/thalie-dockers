#!/bin/bash

. $HOME/secrets/mysql.env

trash="$HOME/trash_servervault"
log="$HOME/logs.0/delete.log"
pass="${DB_PASSWORD:-${MARIADB_PASSWORD}}"
db="${DB_NAME:-${MARIADB_DATABASE}}"
user="${DB_USER:-${MARIADB_USER}}"
host="${DB_HOST:-mysql}"

  function delete_pc_file() {
    acc="$1"
#    file=`echo "$2" | sed -e 's/è/?/g'`  #removing bad characters.
#    file=`echo "$2" | tr 'è' '.'`  #removing bad characters.
    file="$2"
    cd "$HOME/servervault/${acc}/"
#    pwd
    if `ls ./${file}.bic > /dev/null`; then
      echo "removing ./${file}.bic"
      dt=`date +%Y-%m-%d-%I%M%S`
      mv "./${file}.bic" "$trash/${dt}_${acc}_${file}.bic"
#      rm "./${file}.bic"
      return $? 
    else
      echo "Cannot find file ${file} in "`pwd`
      return 2
    fi
  }

  function delete_db_record() {
    id="$1"
    if [ -z "$id" -o "$id" -le "0" ]; then
      echo "Bad db id $id"
      return 2
    fi
    sql="DELETE FROM pwchars where id = '$id';"
    echo $sql
    mysql --database=$db -u $user --password=$pass -e "$sql" -h $host
  }

  function unset_delete_flag() {
    id="$1"
    if [ -z "$id" -o "$id" -le "0" ]; then
      echo "Bad db id $id"
      return 2
    fi
    sql="UPDATE pwchars SET delete_flag = NULL where id = '$id';"
    echo $sql
    mysql --database=$db -u $user --password=$pass -e "$sql" -h $host
  }

  mysql --database=$db -u $user --password=$pass -e "SELECT \
       'line' as header, '|', \
       c.id, '|', \
       f.val, '|', \
       c.player, '|',\
       c.tag \
     from pwdata f, pwchars c where \
       c.delete_flag = '1' AND \
       c.player = f.player AND \
       c.tag = f.tag AND \
       f.name = 'FILENAME';" -h $host | grep -v "^header" | sed -e 's/\t|\t/|/g' | \
   while read line
   do
     id=`echo $line | cut -d '|' -f 2`
     filename=`echo $line | cut -d '|' -f 3 | tr "'~" "'"`
     account=`echo $line | cut -d '|' -f 4`
     char=`echo $line | cut -d '|' -f 5-`

     dt=`date +%Y-%m-%d-%I%M%S`
     echo "$dt Remove '$account' '$char' '$filename' '$id'" >> $log 
     delete_pc_file "$account" "$filename" >> $log 2>&1
     if [ $? -eq "0" ]; then
       delete_db_record "$id" >> $log 2>&1
     else
       echo "Error when removing \"$account\" \"$filename\"" >> $log
#       delete_db_record "$id" >> $log 2>&1
     fi
     
   done
