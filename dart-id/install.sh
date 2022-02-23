#!/bin/bash

# Stop on errors.
set -e

# cd to script directory
script_path=$(dirname "$0")
cd "$script_path" || { echo "Folder $script_path does not exists"; exit 1; }

# Commons functions
source ../commons.sh

version=$1
validate_module_version "$version" dart-id

# Load maxquant module and requirements.
module purge
if [ -z "$version" ]
then
  module load StdEnv/2020 python/3.8.10 dart-id
elif [[ $version =~ ^0\..* ]]
then
  module load StdEnv/2020 python/3.8.10 dart-id/"$version"
else
  module load StdEnv/2020 python/3.8.10 dart-id/"$version"
fi


clean_module_dir "$DART_ID"
echo "Installing dart-id in folder $DART_ID"
cd "$DART_ID" || { echo "Folder $DART_ID does not exists"; exit 1; }

# Create python virtual environment.
venv="$DART_ID"/venv
python3 -m venv "$venv"
"$venv/bin/pip" install dart-id=="$DART_ID_VERSION"
fix_python_shebang "$venv" dartid_python_wrapper.sh

# Fix path to system libraries to be loaded.
setrpaths.sh --path "$DART_ID"
