#!/bin/bash
exit 0

ln=`/bin/ps -eo pid,nice,command,%cpu | /bin/grep  "\./nwserver" | /bin/grep -v grep | /usr/bin/tr -s ' '`; 

nwpid=`/bin/echo $ln | /usr/bin/cut -d ' ' -f 1`; 
nwnice=`/bin/echo $ln | /usr/bin/cut -d ' ' -f 2`; 

if [ "$nwnice" != "-10" ]; then 
  /usr/bin/renice -10 $nwpid > /dev/null; 
fi
