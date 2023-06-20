#!/bin/bash

if [ "$EUID" -ne 0 ]
then
  echo "Please run as root"
  exit 1
fi
if [ -z "$1" ]
then
  echo "Version number must be the first parameter"
  exit 1
fi

# Stop on errors.
set -e

script_dir=$(dirname $(readlink -f "$0"))
version=$1

echo "script dir: $script_dir"
echo "version: $version"

rm -f "maxquant-$version.def"
sed "s/^  MAXQUANT_VERSION=.*$/  MAXQUANT_VERSION=$version/g" "$script_dir/maxquant.def" > "maxquant-$version.def"

echo "Creating Apptainer container for MaxQuant $version"
apptainer build --force "maxquant-$version.sif" "maxquant-$version.def"

rm "maxquant-$version.def"
