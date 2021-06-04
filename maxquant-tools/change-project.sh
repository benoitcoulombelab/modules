#!/bin/bash

if [ -z "$MAXQUANT_TOOLS" ]
then
  echo "MAXQUANT_TOOLS environment variable must be defined, please load a 'maxquant-tools' module"
  exit 1
fi


PROJECT=$1
if [ -z "$PROJECT" ] ; then
  echo "You must supply the project name as the first argument"
  exit 1
fi
if [ ! -d "$HOME/projects/$PROJECT" ] ; then
  echo "Project $PROJECT not present in your projects folder"
  exit 1
fi


cd "$MAXQUANT_TOOLS"
find bash -maxdepth 1 -type f -exec git checkout -- {} \;
find bash -maxdepth 1 -type f -exec sed -i "s/def-coulomb/$PROJECT/g" {} \;
