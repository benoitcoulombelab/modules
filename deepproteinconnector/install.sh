#!/bin/bash

# Stop on errors.
set -e

# cd to script directory
script_path=$(dirname "$0")
cd "$script_path" || { echo "Folder $script_path does not exists"; exit 1; }

# Commons functions
source ../commons.sh

version=$1
validate_module_version "$version" deepproteinconnector

# Load module and requirements.
module purge
if [ -z "$version" ]
then
  module load StdEnv/2020 python/3.10.2 deepproteinconnector
else
  module load StdEnv/2020 python/3.10.2 deepproteinconnector/"$version"
fi


clean_module_dir "$DEEPPROTEINCONNECTOR"
echo "Installing DeepProteinConnector in folder $DEEPPROTEINCONNECTOR"
cd "$DEEPPROTEINCONNECTOR" || { echo "Folder $DEEPPROTEINCONNECTOR does not exists"; exit 1; }
git clone https://github.com/benoitcoulombelab/DeepProteinConnector.git .
if [ "$DEEPPROTEINCONNECTOR_VERSION" == "1.0" ]
then
  git checkout main
else
  git checkout "$DEEPPROTEINCONNECTOR_VERSION"
fi

# Create python virtual environment.
venv="$DEEPPROTEINCONNECTOR"/venv
python3 -m venv "$venv"
cloned_version=$(git --git-dir="$DEEPPROTEINCONNECTOR"/.git rev-parse --abbrev-ref HEAD)
"$venv/bin/pip" install git+file://"$DEEPPROTEINCONNECTOR"@"$cloned_version"

# Fix shebang for python files.
wrapper="$venv/bin/deepproteinconnector_python_wrapper.sh"
write_python_shebang_wrapper "$wrapper" "\$DEEPPROTEINCONNECTOR/venv/bin/python3"
fix_python_shebang "$venv/bin" $(basename "$wrapper")
