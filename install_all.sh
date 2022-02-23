#!/bin/bash
#SBATCH --account=def-coulomb
#SBATCH --time=24:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --mail-type=NONE
#SBATCH --output=install_all-%A.out
#SBATCH --error=install_all-%A.out

install_module () {
  module=$1
  module_dir=$(dirname "$module".lua)
  version=$(basename "$module")
  if [ -f "$module_dir"/install.sh ]
  then
    echo "Installing module $module" 1>&2
    bash "$module_dir"/install.sh "$version" || (echo "Failed installing module $module" 1>&2 && false)
  fi
}
export -f install_module

modules=$(find . -type f -name "*.lua" \( ! -iname ".*" \) | awk '{print substr($0, 3, length($0)-6)}')
threads=1
if [ -n "$SLURM_CPUS_PER_TASK" ]
then
  threads="$SLURM_CPUS_PER_TASK"
fi
parallel -P "$threads" --env install_module install_module ::: "$modules"
