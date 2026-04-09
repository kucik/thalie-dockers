#!/usr/bin/perl

$ENV{PATH} = '/bin';

$PROG = 'nwserver';
$PID = `/bin/pidof $PROG`;

if ($PID =~ /^([ &:#-\@\w.]+)$/) {
$PID = $1; #data is now untainted
} else {
print "bad data\n";
}
`/bin/kill $PID`;
`( /bin/sleep 180 ; /bin/kill -s 9 $PID ) &`; 

