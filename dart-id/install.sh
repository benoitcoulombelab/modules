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

# Load module and requirements.
module purge
if [ -z "$version" ]
then
  module load StdEnv/2020 python/3.8.10 dart-id
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

# Fix shebang for python files.
wrapper="$venv/bin/dartid_python_wrapper.sh"
write_python_shebang_wrapper "$wrapper" "\$DART_ID/venv/bin/python3"
fix_python_shebang "$venv/bin" $(basename "$wrapper")

# Fix path to system libraries to be loaded.
setrpaths.sh --path "$DART_ID"
