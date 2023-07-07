#!/bin/bash

# Stop on errors.
set -e

# cd to script directory
script_path=$(dirname "$0")
cd "$script_path" || { echo "Folder $script_path does not exists"; exit 1; }

# Commons functions
source ../commons.sh

version=$1
validate_module_version "$version" alphafold-pairs

# Load module and requirements.
module purge
if [ -z "$version" ]
then
  module load StdEnv/2020 python/3.10.2 alphafold-pairs
else
  module load StdEnv/2020 python/3.10.2 alphafold-pairs/"$version"
fi


clean_module_dir "$ALPHAFOLD_PAIRS"
echo "Installing AlphaFold-pairs in folder $ALPHAFOLD_PAIRS"
cd "$ALPHAFOLD_PAIRS" || { echo "Folder $ALPHAFOLD_PAIRS does not exists"; exit 1; }
git clone https://github.com/benoitcoulombelab/alphafold-pairs.git .
if [ "$ALPHAFOLD_PAIRS_VERSION" == "1.0" ]
then
  git checkout main
else
  git checkout "$ALPHAFOLD_PAIRS_VERSION"
fi

# Create python virtual environment.
venv="$ALPHAFOLD_PAIRS"/venv
python3 -m venv "$venv"
cloned_version=$(git --git-dir="$ALPHAFOLD_PAIRS"/.git rev-parse --abbrev-ref HEAD)
"$venv/bin/pip" install git+file://"$ALPHAFOLD_PAIRS"@"$cloned_version"

# Fix shebang for python files.
wrapper="$venv/bin/alphafold_pairs_python_wrapper.sh"
write_python_shebang_wrapper "$wrapper" "\$ALPHAFOLD_PAIRS/venv/bin/python3"
fix_python_shebang "$venv/bin" $(basename "$wrapper")
