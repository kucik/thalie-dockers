#!/bin/sh
cd /home/nwn

#Source secrets
. ./secrets/nwn.env
. ./secrets/mysql.env

# Canonical DB credentials come from MARIADB_*; DB_* remain as optional overrides.
DB_HOST="${DB_HOST:-mysql}"
DB_NAME="${DB_NAME:-${MARIADB_DATABASE}}"
DB_USER="${DB_USER:-${MARIADB_USER}}"
DB_PASSWORD="${DB_PASSWORD:-${MARIADB_PASSWORD}}"

#exit 0

## Delete dump table
mysql --database=${DB_NAME} -u ${DB_USER} --password=${DB_PASSWORD} -e "DELETE FROM dump;" -h ${DB_HOST}

## Process delete requests
./scripts/remove_pc.sh

## Set module version 
ls -l /home/nwn/modules/Thalie.mod --time-style="+%Y-%m-%d %H:%M" | cut -d ' ' -f 6,7 > /var/www/thalie/data/moduleversion.dat

## Update nwnx
#cp ./src/compiled/*.so .
#test -e /home/nwn/nwnx_profiler.so && rm /home/nwn/nwnx_profiler.so

#kill previous checker
killall login_checker
#Update library
./scripts/copy_libs.sh

## Move logs
mv logs.0/nwRecvOver.txt logs.0/nwRecvOver_`date +%Y-%m-%d-%I:%M:%S`.txt
mv logs.0/nwnx_profiler.txt logs.0/nwnx_profiler_`date +%Y-%m-%d-%I:%M:%S`.txt
# Start login checker
#./login_checker "${DB_HOST}" "${DB_USER}" "${DB_PASSWORD}" "${DB_NAME}" & 

cp nwnplayer.ini.act nwnplayer.ini

# Keep preload scoped to nwserver only. Exporting it globally also affects
# helper tools (for example tee), which can crash when nwnx2.so is injected.
#NWNX_PRELOAD="./nwnx2.so"
NWNX_PRELOAD="./nwnx2.so ./recvover.so ./libdiehard.so"
#NWNX_PRELOAD="./nwnx2.so ./recvover.so"
#export LD_LIBRARY_PATH=/usr/lib32/:$LD_LIBRARY_PATH

ulimit -c unlimited

LD_PRELOAD="$NWNX_PRELOAD" ./nwserver \
	-publicserver 1 \
	-servername Thalie \
	-dmpassword ${DM_PASSWORD} \
	-oneparty 0 \
	-pvp 2 \
	-difficulty 3 \
	-elc 0 \
	-ilr 1 \
	-reloadwhenempty 0 \
	-module "Thalie" \
	-maxclients 60 \
	-servervault 1 \
	-maxlevel 40 \
	-gametype 10 \
	-autosaveinterval 0 \
2>&1 | tee logs.0/nwserverStatus.txt

## kill checker
killall login_checker


