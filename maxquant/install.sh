#!/bin/bash

# Stop on errors.
set -e

# cd to script directory
script_path=$(dirname "$0")
cd "$script_path" || { echo "Folder $script_path does not exists"; exit 1; }

# Commons functions
source ../commons.sh

version=$1
validate_module_version "$version" maxquant

# Load module and requirements.
module purge
if [ -z "$version" ]
then
  module load StdEnv/2020 maxquant
elif [[ $version =~ ^1\..* ]]
then
  module load StdEnv/2018.3 maxquant/"$version"
else
  module load StdEnv/2020 maxquant/"$version"
fi


clean_module_dir "$MAXQUANT"
echo "Installing MaxQuant in folder $MAXQUANT"
cd "$MAXQUANT" || { echo "Folder $MAXQUANT does not exists"; exit 1; }
FILENAME=MaxQuant-"$MAXQUANT_VERSION".zip
wget --no-check-certificate https://datahub-490-pl6.p.genap.ca/apps/maxquant/"$FILENAME"
unzip "$FILENAME"
mv MaxQuant/* .
rmdir MaxQuant
rm "$FILENAME"
