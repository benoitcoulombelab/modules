#!/bin/bash

if [ -z "$DART_ID" ]
then
  echo "DART_ID environment variable must be defined, please load a 'dart-id' module"
  exit 1
fi


if [ -d "$DART_ID" ]
then
  echo "Deleting old folder $DART_ID"
  rm -rf "$DART_ID"
fi
echo "Installing dart-id in folder $DART_ID"
mkdir -p "$DART_ID"
cd "$DART_ID" || { echo "Folder $DART_ID does not exists"; exit 1; }

# Create python virtual environment.
VENV="$DART_ID"/venv
echo "Creating python virtual environment at $VENV"
python3 -m venv "$VENV"
"$VENV"/bin/pip install dart-id=="$DART_ID_VERSION"

# Fix shebang for python files.
find "$VENV/bin" -type f -executable -exec sed -i "1 s|^#\!.*$|#!/usr/bin/env dartid_python_wrapper.sh|g" {} \;
if [ -f "$VENV"/bin/dartid_python_wrapper.sh ]
then
  rm "$VENV"/bin/dartid_python_wrapper.sh
fi
{
  echo '#!/bin/bash'
  echo 'python="$DART_ID"/venv/bin/python3'
  echo 'exec "$python" "$@"'
} >> "$VENV"/bin/dartid_python_wrapper.sh
chmod 755 "$VENV"/bin/dartid_python_wrapper.sh

# Fix path to system libraries to be loaded.
setrpaths.sh --path "$DART_ID"
