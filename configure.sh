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

# Remove direct configuration of coulombe lab modules, if present.
if grep -Fq "COULOMB_MODULES_DIR=" ~/.bash_profile
then
  echo "Removing Coulombe Lab modules from .bash_profile"
  INDEX=$(grep -n "COULOMB_MODULES_DIR=" ~/.bash_profile | cut -d: -f1)
  sed -i "$((INDEX-1)),$((INDEX+4))d" ~/.bash_profile
fi

# Remove reference to renamed .def-coulomb-addons configuration, if present.
if grep -Fq "source .def-coulomb-addons" ~/.bash_profile
then
  echo "Removing file .def-coulomb-addons from .bash_profile"
  INDEX=$(grep -n "source .def-coulomb-addons" ~/.bash_profile | cut -d: -f1)
  sed -i "$((INDEX-1)),$((INDEX+2))d" ~/.bash_profile
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

# Create .coulombelab-apps-addons file to allow loading of coulombe modules.
if [ -f ~/.coulombelab-apps-addons ]
then
  rm ~/.coulombelab-apps-addons
fi
MODULES_BASE=$(dirname $(readlink -f $0))
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
