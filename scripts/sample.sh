#!/bin/zsh

if [[ -e $HOME/.gitignore_global ]]; then
  echo "true"
else
  echo "false"
fi
