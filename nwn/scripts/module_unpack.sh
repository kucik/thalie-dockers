#!/bin/bash
path="modules"
controll_file=".module_act"

cd $path
modulearch=`ls -t Thalie*.zip | head -n 1`

if [ -z "$modulearch" ]; then
  exit 0
fi

if [ ! -e $controll_file ]; then
  exit 0
fi

if [ $modulearch -nt $controll_file ]; then
#  echo "Extracting $modulearch"
  unzip -qo $modulearch
  echo $modulearch > $controll_file
fi
