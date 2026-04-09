#!/bin/bash

LIBS="nwnx2.so \
nwnx_areas.so \
nwnx_connect.so \
nwnx_dmactions.so \
nwnx_events.so \
nwnx_fixes.so \
nwnx_funcsext.so \
nwnx_funcs.so \
nwnx_odmbc_mysql.so \
nwnx_optimizations.so \
nwnx_resman.so \
nwnx_spells.so \
nwnx_structs.so \
nwnx_visibility.so \
nwnx_weapons.so \
recvover.so \
login_checker"

for lib in $LIBS; do
  cp -v $HOME/nwnx2/$lib $HOME/
done