#!/bin/bash

if [ -z "$MAXQUANT_TOOLS" ]
then
  echo "MAXQUANT_TOOLS environment variable must be defined, please load a 'maxquant-tools' module"
  exit 1
fi


# Clone maxquant-tools, if not already cloned.
if [ ! -d "$MAXQUANT_TOOLS" ]
then
  echo "Creating folder $MAXQUANT_TOOLS"
  mkdir -p "$MAXQUANT_TOOLS"
fi
cd "$MAXQUANT_TOOLS" || { echo "Folder $MAXQUANT_TOOLS does not exists"; exit 1; }
if [ ! -d "$MAXQUANT_TOOLS/.git" ]
then
  echo "Cloning maxquant-tools in folder $MAXQUANT_TOOLS"
  git clone https://github.com/benoitcoulombelab/maxquant-tools.git .
fi
echo "Checking out version $MAXQUANT_TOOLS_VERSION"
if [ "$MAXQUANT_TOOLS_VERSION" == "1.0" ]
then
  git checkout master
else
  git checkout "$MAXQUANT_TOOLS_VERSION"
fi

# Create python virtual environment.
VENV="$MAXQUANT_TOOLS"/venv
if [ ! -d "$VENV" ]
then
  echo "Creating python virtual environment at $VENV"
  python3 -m venv "$VENV"
fi
VERSION=$(git --git-dir="$MAXQUANT_TOOLS"/.git rev-parse --abbrev-ref HEAD)
echo "Updating python libraries using $VERSION"
"$VENV"/bin/pip uninstall -y MAXQUANT_TOOLS
"$VENV"/bin/pip install git+file://"$MAXQUANT_TOOLS"@"$VERSION"
find "$VENV" -type f -perm 750 -exec sed -i "1 s|^.*$|#!/usr/bin/env python3|g" {} \;
