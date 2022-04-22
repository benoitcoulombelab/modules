#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

create_container () {
  local module=$1
  local module_dir=$(dirname "$module".lua)
  local version=$(basename "$module")
  local output
  output=$(bash "$module_dir/singularity-build.sh" "$version" 2>&1)
  local status=$?
  if [ $status -eq 0 ]
  then
    printf "Created Singularity container for MaxQuant version %s\n%s\n\n\n\n" "$version" "$output"
    true
  else
    printf "Failed to create Singularity container for MaxQuant version %s\n%s\n\n\n\n" "$version" "$output"
    false
  fi
}
export -f create_container


script_dir=$(dirname $(readlink -f "$0"))
modules=$(find "$script_dir" -type f -name "*.lua" \( ! -iname ".*" \) | awk '{print substr($0, 1, length($0)-4)}')
parallel --env create_container create_container ::: "$modules"
