#!/bin/bash

# Stop on errors.
set -e

# cd to script directory
script_path=$(dirname "$0")
cd "$script_path" || { echo "Folder $script_path does not exists"; exit 1; }

# Commons functions
source ../commons.sh

version=$1
validate_module_version "$version" alphafold

# Load module and requirements.
module purge
if [ -z "$version" ]
then
  module load StdEnv/2020 python/3.9.6 singularity/3.8 alphafold
else
  module load StdEnv/2020 python/3.9.6 singularity/3.8 alphafold/"$version"
fi


clean_module_dir "$ALPHAFOLD"
echo "Installing alphafold in folder $ALPHAFOLD"
cd "$ALPHAFOLD" || { echo "Folder $ALPHAFOLD does not exists"; exit 1; }
git clone https://github.com/dialvarezs/alphafold.git .
patch="${script_path}/alphafold-${version}.patch"
git checkout "v${ALPHAFOLD_VERSION}"
if [ -f "${patch}" ]
then
  echo "Applying patch file ${patch}"
  git apply "${patch}"
fi
git clone --branch "v${ALPHAFOLD_VERSION}" https://github.com/prehensilecode/alphafold_singularity singularity
pushd singularity
patch="${script_path}/alphafold_singularity-${version}.patch"
if [ -f "${patch}" ]
then
  echo "Applying patch file ${patch}"
  git apply "${patch}"
fi
popd

# Create python virtual environment.
venv="$ALPHAFOLD"/venv
python3 -m venv "$venv"
#echo -e "${ALPHAFOLD_PIP// /\\n}" > requirements-temp.txt
#"$venv/bin/pip" install -r requirements-temp.txt
#rm requirements-temp.txt
"$venv/bin/pip" install -r singularity/requirements.txt

# Install singularity container
if ! wget -nv -O alphafold.sif "https://datahub-490-pl6.p.genap.ca/apps/alphafold/alphafold-${ALPHAFOLD_VERSION}.sif"
then
  echo "AlphaFold singularity container does not exists for MaxQuant version $version"
fi
