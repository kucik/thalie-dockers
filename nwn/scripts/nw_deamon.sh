#!/bin/bash
. $HOME/secrets/mysql.env

  ## check kill command
  result=`mysql --database=$MARIADB_DATABASE -u $MARIADB_USER --password=$MARIADB_PASSWORD -e "SELECT * from server_commands where command = 'killserver';" -h ${DB_HOST} | grep killserver`

  id=`echo $result | cut -d ' ' -f 1`
  if [ -n "$id" ] && [ "$id" -gt 0 ]; then
#    date
#    echo "Delete record $id"
    mysql --database=$MARIADB_DATABASE -u $MARIADB_USER --password=$MARIADB_PASSWORD -e "DELETE from server_commands where id=$id;" -h ${DB_HOST}
#    echo "kill server"
    /usr/bin/killall nwserver
  fi 
