#!/usr/bin/env bash
dsh="$SHELL"

if [[ "$#" -gt 0 ]]; then
  if [[ "${1/--verbose/-v}" == "-v" ]]; then
    "$HOME/.termux/root_files/su98"
  elif [[ "${1/--help/-h}" == "-h" ]]; then
    echo "usage: sud [OPTIONS] [COMMAND...]"
    echo "options: -c command. -v | --verbose. -h | --help"
    exit 0
  else
    "$HOME/.termux/root_files/su98" "$@"
    exit 0
  fi
else
  "$HOME/.termux/root_files/su98" -c "exec $dsh"
fi
