#!/bin/sh
# accepted parameters: $file $factory
# check file
if [ -z "$file" ];
 then
  exit 1
fi
BASE="/root/configurations/custom"
file="$file.cgz"
if [ -f "$BASE/$file" ];
 then
  rm "$BASE/$file""
 else
  exit 1
fi
