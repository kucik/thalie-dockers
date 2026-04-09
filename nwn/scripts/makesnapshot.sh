#!/bin/bash

tar -czvf _backup/snapshot.tgz --exclude='./_backup' --exclude='./modules' --exclude='./trash_servervault' --exclude='./servervault' --exclude='./src' --exclude='./hak/TH'  --exclude='./hak/bck_*' .
