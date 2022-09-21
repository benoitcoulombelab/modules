#!/bin/bash

if [ "$1" == "clean" ]
then
  echo "Removing changes made to .bash_profile"
  if grep -Fq "source .coulombelab-apps-addons" ~/.bash_profile
  then
      INDEX=$(grep -n "source .coulombelab-apps-addons" ~/.bash_profile | cut -d: -f1)
      sed -i "$((INDEX-1)),$((INDEX+2))d" ~/.bash_profile
  fi
  if [ -f ~/.coulombelab-apps-addons ]
  then
      rm ~/.coulombelab-apps-addons
  fi
  exit 0
fi

# Source .coulombelab-apps-addons file on login.
if ! grep -Fq "source .coulombelab-apps-addons" ~/.bash_profile
then
  echo "Adding Coulombe Lab Apps addons"
  {
    echo 'if [ -f .coulombelab-apps-addons ]; then'
    echo '  source .coulombelab-apps-addons'
    echo 'fi'
    echo ""
  }  >> ~/.bash_profile
fi

# Get path to modules.
if [ -d "$HOME"/projects ]
then
  SCRIPT_PATH=$(dirname $(readlink -f "$0"))
  for project in "$HOME"/projects/*
  do
    PROJECT_PATH=$(readlink -f "$project")
    if [[ $SCRIPT_PATH == $PROJECT_PATH/* ]]
    then
      MODULES_BASE=$project/${SCRIPT_PATH:${#PROJECT_PATH}+1}
    fi
  done
fi
if [ -z "$MODULES_BASE" ]
then
  MODULES_BASE=$(dirname $(readlink -f "$0"))
fi

# Create .coulombelab-apps-addons file to allow loading of coulombe modules.
if [ -f ~/.coulombelab-apps-addons ]
then
  rm ~/.coulombelab-apps-addons
fi
{
  echo "## Add Coulombe Lab Modules scripts to PATH ##"
  echo "PATH=$MODULES_BASE:\$PATH"
  echo "export PATH"
  echo ""
  echo "## Coulombe Lab Modules ##"
  echo "MODULES_DIR=$MODULES_BASE"
  echo 'if [ -d "$MODULES_DIR" ]; then'
  echo '  module use $MODULES_DIR'
  echo 'fi'
  echo ""
} >> ~/.coulombelab-apps-addons
