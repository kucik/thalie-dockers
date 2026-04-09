#!/bin/sh

# THALIE OTHER
thalie_repo_url=https://github.com/kucik/thalie.git
thalie_dlg_repo_url=https://github.com/kucik/thalie-dlg.git
mkdir -p $HOME/src/thalie
mkdir -p $HOME/src/thalie-dlg
mkdir -p $HOME/resman/uti
mkdir -p $HOME/resman/utm
mkdir -p $HOME/resman/utp
mkdir -p $HOME/resman/utc
mkdir -p $HOME/resman/dlg

cd $HOME/src/thalie; 

if [ ! -d .git ]; then 
  git clone ${thalie_repo_url} .;
fi
pull=`git pull`; 

if [ "$pull" != "Already up-to-date." ]; then 
  cd craft 
  cp uti/*.uti $HOME/resman/uti/ 
  cp utm/*.utm $HOME/resman/utm/ 
  cp utp/*.utp $HOME/resman/utp/ 
  
  cd ../spawn
  cp uti/*.uti $HOME/resman/uti/
  cp utc/*.utc $HOME/resman/utc/
fi

# SCRIPTS
#cd $HOME/src/thalie-scripts;
#git pull

# DLG
cd $HOME/src/thalie-dlg;
if [ ! -d .git ]; then 
  git clone ${thalie_dlg_repo_url} .;
fi
pull=`git pull`; 
if [ "$pull" != "Already up-to-date." ]; then 
  cp *.dlg $HOME/resman/dlg/; 
fi 
