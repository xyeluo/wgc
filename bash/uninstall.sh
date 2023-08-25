#!/usr/bin/env bash

_INSTALL_PATH="$HOME/.config/wgc"

function _echo() {
  local msg
  case "$1" in
  "success") msg="\e[32m${2}\e[0m" ;;
  "error") msg="\e[0;31m${2}\e[0m" ;;
  "reverse") msg="\e[7;32m${2}\e[0m" ;;
  esac
  echo -e "$msg"
}

function _restore_file() {
  local origin_file_name origin_file_path
  origin_file_name=$(basename "$1" '.bck')
  origin_file_path="${1%/*}/$origin_file_name"
  if [ -f "${1}" ]; then
    mv "$1" "$origin_file_path" &&
      echo "restore file ${1} to $origin_file_name"
  else
    if [ -f "$origin_file_path" ]; then
      rm -rf "$origin_file_path"
    fi
    echo "not exists ${1}"
  fi
}

function wgc_uninstall() {
  if [ -d "$_INSTALL_PATH" ]; then
    local base_path='/etc/profile.d/'
    rm -rf "$_INSTALL_PATH"
    _restore_file "${HOME}/.vimrc.bck" &&
      _restore_file "${base_path}git-prompt.sh.bck" &&
      _restore_file "${base_path}aliases.sh.bck" &&
      _echo "success" "Wgc succeed remove!\nTerminal needs to be restarted!"
  else
    _echo "error" "not install wgc"
  fi
}
