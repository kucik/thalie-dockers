#!/usr/bin/perl

$PROG = 'nwserver';
$PATH = '/home/nwn';
$DATA = '/var/www/thalie/data';
#exit 0

sleep 60; #because of problems with mysql
while(true){
	$PID = `pidof $PROG`;
	
	if ($PID =~ /\w/ ) {
	}
	else{
		$DATE = `date +%F-%T`;
		`mv $PATH/logs.0/nwserverLog1.txt $PATH/logs.0/nwserverLog_$DATE`;
		`date +%H:%M > $DATA/restart.dat`;

#		if(fork() == 0){	
#			exec("/root/ban_port.sh");
#		}

		`screen -dm su nwn $PATH/start.sh`;
		
		sleep 1;
		
#		$PID = `pidof nwserver`;
#		`renice -1 $PID`;
	}
	
	sleep 60;
}
