#!/bin/bash

if [ -z "$MAXQUANT" ]
then
  echo "MAXQUANT environment variable must be defined, please load a 'maxquant' module"
  exit 1
fi


if [ -d "$MAXQUANT" ]
then
  echo "Deleting old folder $MAXQUANT"
  rm -rf "$MAXQUANT"
fi
echo "Installing MaxQuant in folder $MAXQUANT"
mkdir -p "$MAXQUANT"
cd "$MAXQUANT" || { echo "Folder $MAXQUANT does not exists"; exit 1; }
FILENAME=MaxQuant-"$MAXQUANT_VERSION".zip
wget https://datahub-490-pl6.p.genap.ca/apps/maxquant/"$FILENAME"
unzip "$FILENAME"
mv MaxQuant/* .
rmdir MaxQuant
rm "$FILENAME"
