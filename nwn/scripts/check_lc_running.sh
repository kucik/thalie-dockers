#!/bin/sh

if `ps -u nwn | grep nwserver > /dev/null`
  then
#  echo "nwn server running"
  if `ps -u nwn | grep login_checker > /dev/null`
    then
#    echo "login checker running"
    exit 1
  else
    echo "!!!  Login checker not running! "
    exit 0
  fi
fi 

exit 1
