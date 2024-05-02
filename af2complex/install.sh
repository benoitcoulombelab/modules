#!/bin/bash

# Stop on errors.
set -e

# cd to script directory
script_path=$(dirname $(readlink -f "$0"))
cd "$script_path" || { echo "Folder $script_path does not exists"; exit 1; }

# Commons functions
source ../commons.sh

version=$1
validate_module_version "$version" af2complex

# Load module and requirements.
module purge
module load StdEnv/2020 gcc/9.3.0 openmpi/4.0.3 cuda/11.4 cudnn/8.2.0 kalign/2.03 hmmer/3.2.1 openmm-alphafold/7.5.1 \
            hh-suite/3.3.0 python/3.8 alphafold/2.3.2
if [ -z "$version" ]
then
  module load af2complex
else
  module load af2complex/"$version"
fi


clean_module_dir "$AF2COMPLEX"
echo "Installing AF2Complex in folder $AF2COMPLEX"
cd "$AF2COMPLEX" || { echo "Folder $AF2COMPLEX does not exists"; exit 1; }
git clone https://github.com/FreshAirTonight/af2complex.git .
git checkout "${AF2COMPLEX_VERSION}"
patch="${script_path}/af2complex-${version}.patch"
cp "$patch" .
git apply "$patch"

# Create python virtual environment.
venv="$AF2COMPLEX"/venv
virtualenv --no-download "$venv"
pip install --no-index --upgrade pip
pip install --no-index networkx==2.5.1
pip freeze > "${AF2COMPLEX}/af2complex-requirements.txt"
