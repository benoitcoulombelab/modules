#!/bin/bash

# Stop on errors.
set -e

# cd to script directory
script_path=$(dirname "$0")
cd "$script_path" || { echo "Folder $script_path does not exists"; exit 1; }

# Commons functions
source ../commons.sh

version=$1
validate_module_version "$version" aria2

# Load module and requirements.
module purge
if [ -z "$version" ]
then
  module load StdEnv/2020 python/3.9.6 aria2
else
  module load StdEnv/2020 python/3.9.6 aria2/"$version"
fi


clean_module_dir "$ARIA2"
echo "Installing aria2 in folder $ARIA2"
cd "$ARIA2" || { echo "Folder $ARIA2 does not exists"; exit 1; }
git clone https://github.com/aria2/aria2.git .
git checkout "release-${ARIA2_VERSION}"

# Create python virtual environment for manual entry.
venv="$ARIA2"/venv
python3 -m venv "$venv"
source "$venv/bin/activate"
"$venv/bin/pip" install Sphinx

# Compile aria2.
autoreconf -i || autoreconf -if  # First call often fails
./configure
make
mkdir bin
ln -f src/aria2c bin/aria2c
mkdir -p doc/man/man1
ln -f doc/manual-src/en/_build/man/aria2c.1 doc/man/man1/aria2c.1
