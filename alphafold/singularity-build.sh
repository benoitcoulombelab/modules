#!/bin/bash

if [ "$EUID" -ne 0 ]
then
  echo "Please run as root"
  exit 1
fi
if [ -z "$1" ]
then
  echo "Version number must be the first parameter"
  exit 1
fi

# exit when any command fails
set -e

version=$1
container=alphafold-${version}.sif

singularity build "${container}" "docker://catgumag/alphafold:${version}"

