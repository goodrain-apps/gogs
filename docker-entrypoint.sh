#!/bin/bash

Dirs="/data/gogs/data /data/gogs/conf /data/gogs/log /data/git /data/ssh"

# Create VOLUME subfolder
for d in $Dirs
do
  [ ! -d $d ] && mkdir -pv $d
done
