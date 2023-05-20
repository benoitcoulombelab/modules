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

version=$1
container=alphafold-${version}.sif
current_dir="$PWD"

# Commons functions
source ../commons.sh

temp_dir=$(create_temporary_directory)
trap "delete_temporary_directory ${temp_dir}; echo Deleted dir ${temp_dir}" EXIT
cd "$temp_dir"
git clone -b "v${version}" https://github.com/deepmind/alphafold.git
cd alphafold
patch="${current_dir}/alphafold-${version}.patch"
if [ -f "${patch}" ]
then
  echo "Applying patch file ${patch}"
  git apply "${patch}"
fi
echo "Installing python requirements"
python3 -m venv singularity-venv
source singularity-venv/bin/activate
git clone -b "v${version}" https://github.com/prehensilecode/alphafold_singularity.git singularity
pushd singularity
patch="${current_dir}/alphafold_singularity-${version}.patch"
if [ -f "${patch}" ]
then
  echo "Applying patch file ${patch}"
  git apply "${patch}"
fi
popd
python3 -m pip install -r singularity/requirements.txt
echo "Creating singularity image"
singularity build "${current_dir}/${container}" singularity/Singularity.def
