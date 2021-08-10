#!/bin/bash

file=$1
if [ -z "$file" ]
then
  file=$(pwd)
fi

if [ -d "$file" ]
then
  echo "Adding write permission for group to files and directories inside $file"
  chmod -R ug+w "$file"
elif [ -f "$file" ]
then
  echo "Adding write permission for group to file $file"
  chmod ug+w "$file"
else
  echo "$file is not a file or directory"
  exit 1
fi
