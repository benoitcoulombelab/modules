#!/bin/bash

# Stop on errors.
set -e

# cd to script directory
script_path=$(dirname "$0")
cd "$script_path" || { echo "Folder $script_path does not exists"; exit 1; }

# Commons functions
source ../commons.sh

version=$1
validate_module_version "$version" maxquant-tools

# Load maxquant module and requirements.
module purge
if [ -z "$version" ]
then
  module load StdEnv/2020 python/3.8.10 maxquant-tools
elif [[ $version =~ ^0\..* ]]
then
  module load StdEnv/2020 python/3.8.10 maxquant-tools/"$version"
else
  module load StdEnv/2020 python/3.8.10 maxquant-tools/"$version"
fi


clean_module_dir "$MAXQUANT_TOOLS"
echo "Installing maxquant-tools in folder $MAXQUANT_TOOLS"
cd "$MAXQUANT_TOOLS" || { echo "Folder $MAXQUANT_TOOLS does not exists"; exit 1; }
git clone https://github.com/benoitcoulombelab/maxquant-tools.git .
if [ "$MAXQUANT_TOOLS_VERSION" == "1.0" ]
then
  git checkout master
else
  git checkout "$MAXQUANT_TOOLS_VERSION"
fi

# Create python virtual environment.
venv="$MAXQUANT_TOOLS"/venv
python3 -m venv "$venv"
cloned_version=$(git --git-dir="$MAXQUANT_TOOLS"/.git rev-parse --abbrev-ref HEAD)
"$venv/bin/pip" install git+file://"$MAXQUANT_TOOLS"@"$cloned_version"
fix_python_shebang "$venv" maxquanttools_python_wrapper.sh "\$MAXQUANT_TOOLS"
