#!/bin/bash

workdir="/home/nwn/servervault"
cd $workdir
tmpdir="tmp_frozen"

function safeunpack() {
  mkdir -p "$tmpdir"
  cd "$tmpdir"
  suff=`echo $1 | cut -d '.' -f 2`
  pwd
  if [ "$suff" = "tgz" ]
  then
    echo "tar -xzvf ../$1"
    tar -xzvf "../$1"
  fi
  if [ "$suff" = "rar" ]
  then
    echo "unrar x \"../$1\""
    unrar x "../$1"
  fi
  mv -nv *.bic ../
  mv -nv frozen*/*.bic ../
  rm -v *.bic
  rm -v */*.bic
  rmdir frozen*
  cd -
  rmdir "$tmpdir"
}

function unfreezeacc() {
  p=$1
  cd $p
  for i in `ls -ta frozen*`; do
    safeunpack "$i"
  done
  cd $workdir
}

for f in $(dirname $(realpath $(ls */*frozen*)) | sort -u)
do
  echo "$f"
  unfreezeacc "$f"
done 
