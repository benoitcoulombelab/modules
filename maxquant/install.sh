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
filename=MaxQuant-"$MAXQUANT_VERSION".zip
wget -nv --no-check-certificate https://datahub-490-pl6.p.genap.ca/apps/maxquant/"$filename"
unzip "$filename"
rm "$filename"
singularity=maxquant-"$MAXQUANT_VERSION".sif
if ! wget -nv --no-check-certificate https://datahub-490-pl6.p.genap.ca/apps/maxquant/"$singularity"
then
  echo "MaxQuant singularity container does not exists for MaxQuant version $version"
fi
