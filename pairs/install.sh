#!/bin/bash

# Stop on errors.
set -e

# cd to script directory
script_path=$(dirname "$0")
cd "$script_path" || { echo "Folder $script_path does not exists"; exit 1; }

# Commons functions
source ../commons.sh

version=$1
validate_module_version "$version" pairs

# Load module and requirements.
module purge
if [ -z "$version" ]
then
  module load StdEnv/2020 python/3.10.2 pairs
else
  module load StdEnv/2020 python/3.10.2 pairs/"$version"
fi


clean_module_dir "$PAIRS"
echo "Installing PAIRS in folder $PAIRS"
cd "$PAIRS" || { echo "Folder $PAIRS does not exists"; exit 1; }
git clone https://github.com/benoitcoulombelab/pairs.git .
if [ "$PAIRS_VERSION" == "1.0" ]
then
  git checkout main
else
  git checkout "$PAIRS_VERSION"
fi

# Create python virtual environment.
venv="$PAIRS"/venv
python3 -m venv "$venv"
cloned_version=$(git --git-dir="$PAIRS"/.git rev-parse --abbrev-ref HEAD)
"$venv/bin/pip" install git+file://"$PAIRS"@"$cloned_version"

# Fix shebang for python files.
wrapper="$venv/bin/pairs_python_wrapper.sh"
write_python_shebang_wrapper "$wrapper" "\$PAIRS/venv/bin/python3"
fix_python_shebang "$venv/bin" $(basename "$wrapper")
