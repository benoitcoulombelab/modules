#!/bin/bash

# Stop on errors.
set -e

# cd to script directory
script_path=$(dirname "$0")
cd "$script_path" || { echo "Folder $script_path does not exists"; exit 1; }

# Commons functions
source ../commons.sh

version=$1
validate_module_version "$version" alphafold-interactions

# Load module and requirements.
module purge
if [ -z "$version" ]
then
  module load StdEnv/2020 python/3.10.2 alphafold-interactions
else
  module load StdEnv/2020 python/3.10.2 alphafold-interactions/"$version"
fi


clean_module_dir "$ALPHAFOLD_INTERACTIONS"
echo "Installing alphafold-interactions in folder $ALPHAFOLD_INTERACTIONS"
cd "$ALPHAFOLD_INTERACTIONS" || { echo "Folder $ALPHAFOLD_INTERACTIONS does not exists"; exit 1; }
git clone https://github.com/benoitcoulombelab/alphafold-interactions.git .
if [ "$ALPHAFOLD_INTERACTIONS_VERSION" == "1.0" ]
then
  git checkout main
else
  git checkout "$ALPHAFOLD_INTERACTIONS_VERSION"
fi

# Create python virtual environment.
venv="$ALPHAFOLD_INTERACTIONS"/venv
python3 -m venv "$venv"
cloned_version=$(git --git-dir="$ALPHAFOLD_INTERACTIONS"/.git rev-parse --abbrev-ref HEAD)
"$venv/bin/pip" install git+file://"$ALPHAFOLD_INTERACTIONS"@"$cloned_version"

# Fix shebang for python files.
wrapper="$venv/bin/alphafold_interactions_python_wrapper.sh"
write_python_shebang_wrapper "$wrapper" "\$ALPHAFOLD_INTERACTIONS/venv/bin/python3"
fix_python_shebang "$venv/bin" $(basename "$wrapper")
