#!/usr/bin/env bash

function _wgc_help() {
  echo -e "Usage: wgc [options]
  \nOptions:
  \t -i,--install       \t add files for _prompt,_alias,and so on to home path
  \t -uni,--uninstall   \t remove generated files by installation
  \t -h,--help          \t output usage information
  "
  return 1
}

_install_path="$HOME/.config/wgc"
_profile_path="$HOME/.bash_profile"
function _i_alias() {
  alias_path="./bash/_alias"
  head="#!/usr/bin/env bash\t
_PROXY='://127.0.0.1:7890'\t"
  # shellcheck disable=SC1091
  source "./src/alias/main" &&
    echo -e "$head" >"$alias_path" &&
    alias >>"$alias_path"
}

function _wgc_install() {
  if [ -d "$_install_path" ]; then
    echo "directory \"$_install_path\" exists"
    return
  fi
  _i_alias
  _profile_path="$HOME/.bash_profile"
  cp -r "./bash/" "$_install_path/"

  # if exists $_profile_path file,backup it
  if [ -f "$_profile_path" ]; then
    cp "$_profile_path" "$_profile_path.bck"
    echo "backup bash_profile to $_profile_path.bck"
  fi

  # write source path to $_profile_path
  echo -e "\t" >>"$_profile_path"
  # shellcheck disable=SC2016
  echo 'start_path="$HOME/.config/wgc/"
[[ -f $start_path"main" ]] && source $start_path"main"' >>"$_profile_path"
  echo "wgc succeed install"
}

function _wgc_uninstall() {
  if [ -d "$_install_path" ]; then
    rm -rf "$_install_path"
    mv "$_profile_path"".bck" "$_profile_path"
    echo "wgc succeed  remove"
  else
    echo "not install wgc"
  fi
}

function _wgc_parse_options() {
  if [[ -z "$1" ]]; then
    _wgc_install
    return
  fi
  case "$1" in
  -i | --install) _wgc_install ;;
  -uni | --uninstall) _wgc_uninstall ;;
  *) _wgc_help ;;
  esac
}

_wgc_parse_options "$@"
