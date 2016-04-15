#!/bin/bash

PermanentDir="/data"
Dirs="gogs/data gogs/conf gogs/log git ssh"

# Create VOLUME subfolder
for d in $Dirs
do
  [ ! -d ${PermanentDir}/${d} ] && mkdir -pv $PermanentDir/${d}
done
