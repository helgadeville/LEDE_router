#!/bin/sh
# accepted parameters: $file
# check file
if [ -z "$file" ];
 then
  exit 1
fi
BASE="/root/configurations/custom"
if [ -f "$BASE/$file" ];
 then
  rm "$BASE/$file"
 else
  exit 1
fi
