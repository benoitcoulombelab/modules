#!/bin/bash

# Stop on errors.
set -e

# cd to script directory
script_path=$(dirname $(readlink -f "$0"))
cd "$script_path" || { echo "Folder $script_path does not exists"; exit 1; }

# Commons functions
source ../commons.sh

version=$1
validate_module_version "$version" alphafold

# Load module and requirements.
module purge
module load StdEnv/2020 gcc/9.3.0 openmpi/4.0.3 cuda/11.4 cudnn/8.2.0 kalign/2.03 hmmer/3.2.1 openmm-alphafold/7.5.1 \
            hh-suite/3.3.0 python/3.8
if [ -z "$version" ]
then
  module load alphafold
else
  module load alphafold/"$version"
fi
version="${ALPHAFOLD_VERSION}"


clean_module_dir "$ALPHAFOLD"
echo "Installing alphafold in folder $ALPHAFOLD"
cd "$ALPHAFOLD" || { echo "Folder $ALPHAFOLD does not exists"; exit 1; }
patch="${script_path}/alphafold-${version}.patch"
cp "$patch" .

# Create python virtual environment.
venv="$ALPHAFOLD"/venv
virtualenv --no-download "$venv"
pip install --no-index --upgrade pip
pip install --no-index alphafold=="${version}"
pip freeze > "${ALPHAFOLD}/alphafold-requirements.txt"
pushd "${venv}/bin"
git apply "$patch"
popd

# Fix shebang for python files.
wrapper="$venv/bin/alphafold_python_wrapper.sh"
write_python_shebang_wrapper "$wrapper" "\${ALPHAFOLD}/venv/bin/python3"
fix_python_shebang "$venv/bin" $(basename "$wrapper")
