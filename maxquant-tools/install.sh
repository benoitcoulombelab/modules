#!/bin/bash

if [ -z "$MAXQUANT_TOOLS" ]
then
  echo "MAXQUANT_TOOLS environment variable must be defined, please load a 'maxquant-tools' module"
  exit 1
fi


if [ -d "$MAXQUANT_TOOLS" ]
then
  echo "Deleting old folder $MAXQUANT_TOOLS"
  rm -rf "$MAXQUANT_TOOLS"
fi
echo "Installing maxquant-tools in folder $MAXQUANT_TOOLS"
mkdir -p "$MAXQUANT_TOOLS"
cd "$MAXQUANT_TOOLS" || { echo "Folder $MAXQUANT_TOOLS does not exists"; exit 1; }
git clone https://github.com/benoitcoulombelab/maxquant-tools.git .
echo "Checking out version $MAXQUANT_TOOLS_VERSION"
if [ "$MAXQUANT_TOOLS_VERSION" == "1.0" ]
then
  git checkout master
else
  git checkout "$MAXQUANT_TOOLS_VERSION"
fi

# Create python virtual environment.
VENV="$MAXQUANT_TOOLS"/venv
echo "Creating python virtual environment at $VENV"
python3 -m venv "$VENV"
VERSION=$(git --git-dir="$MAXQUANT_TOOLS"/.git rev-parse --abbrev-ref HEAD)
echo "Updating python libraries using $VERSION"
"$VENV"/bin/pip install git+file://"$MAXQUANT_TOOLS"@"$VERSION"

# Fix shebang for python files.
find "$VENV/bin" -type f -executable -exec sed -i "1 s|^#\!.*$|#!/usr/bin/env maxquanttools_python_wrapper.sh|g" {} \;
if [ -f "$VENV"/bin/maxquanttools_python_wrapper.sh ]
then
  rm "$VENV"/bin/maxquanttools_python_wrapper.sh
fi
{
  echo '#!/bin/bash'
  echo 'python="$MAXQUANT_TOOLS"/venv/bin/python3'
  echo 'exec "$python" "$@"'
} >> "$VENV"/bin/maxquanttools_python_wrapper.sh
chmod 755 "$VENV"/bin/maxquanttools_python_wrapper.sh
