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
maxquant_def="maxquant.def"
if [ "$version" \< "2.5" ]
then
  maxquant_def="maxquant-2.4.def"
fi

echo "script dir: $script_dir"
echo "version: $version"
echo "source maxquant.def file: $maxquant_def"

rm -f "maxquant-$version.def"
sed "s/^  MAXQUANT_VERSION=.*$/  MAXQUANT_VERSION=$version/g" "$script_dir/$maxquant_def" > "maxquant-$version.def"

echo "Creating Apptainer container for MaxQuant $version"
apptainer build --force "maxquant-$version.sif" "maxquant-$version.def"

rm "maxquant-$version.def"
