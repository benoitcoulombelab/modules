#!/bin/bash

validate_module_version () {
  version=$1
  name=$2
  if [ -z "$version" ] && [ ! -f .modulerc.lua ]
  then
    echo "Version of $name module to install is required"
    exit 1
  fi
  if [ -n "$version" ] && [ ! -f "$version".lua ]
  then
    echo "Version $version of $name module does not exists"
    exit 1
  fi
}

clean_module_dir () {
  dir=$1
  if [ -d "$dir" ]
  then
    echo "Deleting folder $dir"
    rm -rf "$dir"
  fi
  mkdir -p "$dir"
}

get_project_name () {
  account="def-coulomb" # Defaults to def-coulomb
  if [ -d "$HOME"/projects ]
  then
    script=$(dirname $(readlink -f "$PWD"))
    for project in "$HOME"/projects/*
    do
      project_path=$(readlink -f "$project")
      if [[ $script == $project_path/* ]]
      then
        account=$(basename "$project")
      fi
    done
  fi
  echo "$account"
}

fix_python_shebang () {
  venv=$1
  wrapper=$2
  module_var=$3
  find "$venv/bin" -type f -executable -exec sed -i "1 s|^#\!.*$|#!/usr/bin/env $wrapper|g" {} \;
  if [ -f "$venv/bin/$wrapper" ]
  then
    rm "$venv/bin/$wrapper"
  fi
  {
    echo "#!/bin/bash"
    echo "python=$module_var/venv/bin/python3"
    echo "exec \$python \$@"
  } >> "$venv/bin/$wrapper"
  chmod 755 "$venv/bin/$wrapper"
}
