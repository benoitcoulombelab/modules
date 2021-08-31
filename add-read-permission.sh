#!/bin/bash

file=$1
if [ -z "$file" ]
then
  file=$(pwd)
fi

if [ -d "$file" ]
then
  echo "Adding read permission to files and directories inside $file"
  find "$file" -type d -exec chmod a+rx {} \;
  find "$file" -type f -exec chmod a+r {} \;
elif [ -f "$file" ]
then
  echo "Adding read permission to file $file"
  chmod a+r "$file"
else
  echo "$file is not a file or directory"
  exit 1
fi
