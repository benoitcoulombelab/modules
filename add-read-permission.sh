#!/bin/bash

file=$1
if [ -z "$file" ]
then
  file=$(pwd)
fi

if [ -d "$file" ]
then
  echo "Adding read permission to files and directories inside $file"
  chmod -R a+r "$file"
elif [ -f "$file" ]
then
  echo "Adding read permission to file $file"
  chmod a+r "$file"
else
  echo "$file is not a file or directory"
  exit 1
fi
