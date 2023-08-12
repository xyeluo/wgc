#!/usr/bin/env bash
# shellcheck disable=SC1090,SC1091,SC2016

source "bash/uninstall.sh"

_WGC_FILE_NOTE="Generated by wgc,If you want to modify this file, uninstall the wgc and then modify it!!!"
_INSTALL_SUCCESS_INFO="\nTerminal needs to be restarted to run it!"

# command
_INSTALL_CMD=('i' 'install' 'add files for _prompt,_alias,and so on to home path')
_PROMPT_CMD=('p' 'prompt' 'only install prompt')
_ALIAS_CMD=('a' 'alias' 'only install alias')
_HELP_CMD=('h' 'help' 'output usage information')
_UNINSTALL_CMD=('uni' 'uninstall' 'remove generated files by installation')

_ALL_CMD=(
  "${_INSTALL_CMD[@]}"
  "${_PROMPT_CMD[@]}"
  "${_ALIAS_CMD[@]}"
  "${_HELP_CMD[@]}"
  "${_UNINSTALL_CMD[@]}"
)

function _i_alias() {
  _e_init 'alias'
  local alias_path="./bash/_alias"
  local head="#!/usr/bin/env bash\n"

  local git_al='/etc/profile.d/aliases.sh'
  [ -f "$git_al" ] && source $git_al && _backup_file "$git_al" && rm -rf "$git_al"
  touch $alias_path
  source "./src/alias/main" &&
    echo -e "$head" >"$alias_path" &&
    alias >>"$alias_path"
}

function _i_prompt() {
  _e_init 'prompt'

  # Run 'cd /etc/profile.d' in the Windows system and comment out all contents of git-prompt.sh,
  # because 'PS1' is generated by _prompt file,so the file is not needed.
  local git_pr='/etc/profile.d/git-prompt.sh'
  [ -f "$git_pr" ] && _backup_file "$git_pr"

  # and 'git_cpl' only exist in windows, it's used for git command completion
  local git_cpl='/mingw64/share/git/completion/git-completion.bash'
  if [ -f "$git_cpl" ] && [ -f $git_pr ]; then
    echo -e "# $_WGC_FILE_NOTE\n" >"$git_pr"
    echo "source '$git_cpl'" >>"$git_pr"
  fi
}

function _i_profile() {
  _e_init 'profile'

  # install profile config
  # backup profile
  local profile_path="$HOME/.bash_profile"

  # if system is not Windows
  if [[ ! "$OSTYPE" =~ ^msys ]]; then
    profile_path="$HOME/.bashrc"
  fi
  _backup_file "$profile_path"
  echo -e "\n$1" >>"$profile_path"
}

function _i_vimrc() {
  _e_init 'vimrc'

  # install vimrc config
  _backup_file "$HOME/.vimrc" '"---' '---"'
  cat "./src/.vimrc" >>"$HOME/.vimrc"
}

function _wgc_help() {
  local short long desc
  echo -e "Usage: wgc [options]
  \nOptions:"
  for ((i = 0; i < ${#_ALL_CMD[@]}; i += 3)); do
    short=${_ALL_CMD[$i]}
    long="--${_ALL_CMD[$i + 1]}"
    desc=${_ALL_CMD[$i + 2]}
    printf "\t %-15s\t %-40s\t\n" "$short,$long" "$desc"
  done
  exit 1
}

function _e_init() {
  echo "init $1 config..."
}

function _backup_file() {
  # if exists $_PROFILE_PATH file,backup it
  if [ -f "$1" ]; then
    cp "$1" "${1}.bck"
    echo "backup $(basename "$1") to ${1}.bck"
  fi
  local msg_pre=${2:-' #'}
  local msg_suffix=${3:-''}
  local note="$msg_pre $_WGC_FILE_NOTE $msg_suffix"
  echo -e "$note\n" >"$1"
  [ -f "${1}.bck" ] && cat "${1}.bck" >>"$1"
}

function _check_is_install_wgc() {
  if [ -d "$_INSTALL_PATH" ]; then
    _echo "error" "directory \"$_INSTALL_PATH\" exists,uninstall the wgc and then install it"
    exit 1
  fi
}

# _alone_install $install_cmd $install_file_name
function _alone_install() {
  local cmd="$1"
  local file_name="$2"
  _check_is_install_wgc
  $cmd
  [ ! -d "$_INSTALL_PATH" ] && mkdir "$_INSTALL_PATH"
  cp "./bash/${file_name}" "${_INSTALL_PATH}/${file_name}"
  _i_profile "source '${_INSTALL_PATH}/${file_name}'"
  file_name="${file_name:1}"
  file_name="${file_name^}"
  _echo "success" "${file_name} of wgc succeed install!${_INSTALL_SUCCESS_INFO}"
}
function _wgc_install_prompt() {
  _alone_install _i_prompt '_prompt'
}

function _wgc_install_alias() {
  _alone_install _i_alias '_alias'
}

function _wgc_install() {
  _check_is_install_wgc
  _i_alias
  _i_prompt

  cp -r "./bash/" "$_INSTALL_PATH/"

  _i_vimrc
  local start_path="${HOME}/.config/wgc/"

  # shellcheck disable=SC2154
  _i_profile "[[ -f '${start_path}main' ]] && source '${start_path}main'"
  _echo "success" "Wgc succeed install!${_INSTALL_SUCCESS_INFO}"
}

function _wgc_parse_options() {
  if [[ -z "$1" ]]; then
    _wgc_install
    return
  fi
  case "$1" in
  "${_INSTALL_CMD[0]}" | --"${_INSTALL_CMD[1]}") _wgc_install ;;
  "${_PROMPT_CMD[0]}" | --"${_PROMPT_CMD[1]}") _wgc_install_prompt ;;
  "${_ALIAS_CMD[0]}" | --"${_ALIAS_CMD[1]}") _wgc_install_alias ;;
  "${_UNINSTALL_CMD[0]}" | --"${_UNINSTALL_CMD[1]}") wgc_uninstall ;;
  *) _wgc_help ;;
  esac
}

_wgc_parse_options "$@"
