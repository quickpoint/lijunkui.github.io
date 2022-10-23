#!/usr/bin/env bash
###########################################################
# update.sh
# @author quickpoint
# @version 1.0 2019-07-20

# update.sh will update the linux to the lastest version and
# clean up the additional resources with one click.
###########################################################
set -euo pipefail
shopt -s globstar nullglob extglob

## @func_color_echo
## @param color color for the echo text
## @param prefix prefox for the echo text
## @param text text for echo
@func_color_echo() {
    if (($# != 3)); then
        echo -e "${FUNCNAME[0]}: <color>  <prefix> <text>."
        exit 1
    fi

    local color="$1"
    local prefix="$2"
    shift 2
    local text="$*"

    local COLOR_BEGIN="\033[1;"
    local COLOR_END="\033[0m"

    echo -e "${COLOR_BEGIN}${color}m${prefix} ${text}${COLOR_END}"
}
export -f @func_color_echo

## @func_info
@func_info() {
    local GREEN=32
    @func_color_echo "${GREEN}" "[INFO]" "$*"
}
export -f @func_info

## @func_warn
@func_warn() {
    local YELLOW=33
    @func_color_echo "${YELLOW}" "[WARN]" "$*"
}
export -f @func_warn

## @func_error
@func_error() {
    local RED=31
    @func_color_echo "${RED}" "[ERROR]" "$*"
}
export -f @func_error

func_step_run() {
    if (($# != 2)); then
        @func_error "${FUNCNAME[0]} <declare><cmd>"
        exit 1
    fi

    local declare="$1"
    shift
    local cmd="$*"

    @func_warn "---------------${declare}---------------"
    ${cmd}
}

func_step_purge() {
    sudo deborphan | xargs sudo apt-get -y remove --purge
}

func_step_uninstall_dup_image() {
    sudo dpkg --get-selections | grep linux-image
    @func_info "sudo apt-get remove --purge linux-image-3.2.2.1-generic"
}

func_rm_locks_if_exists() {
    func_rm_apt_locks_if_exists
    func_rm_dpkg_locks_if_exists
}

func_rm_apt_locks_if_exists() {
    local LOCK="/var/lib/apt/lists/lock"
    func_safe_rm "${LOCK}"
}

func_rm_dpkg_locks_if_exists() {
    local LOCK_FRONTEND="/var/lib/dpkg/lock-frontend"
    func_safe_rm "${LOCK_FRONTEND}"

    local LOCK="/var/lib/dpkg/lock"
    func_safe_rm "${LOCK}"
}

func_safe_rm() {
    local target="$*"

    if [[ -f "${target}" ]]; then
        @func_info "removing ${target}"
        sudo rm "${target}"
    fi
}

func_main() {
    func_step_run "[INIT]" 'func_rm_locks_if_exists'
    func_step_run "[UPDATE]" 'sudo apt-get update'
    func_step_run "[UPDATE]" 'sudo apt-get upgrade -y'
    func_step_run "[DIST-UPDATE]" 'sudo apt-get dist-upgrade -y'
    func_step_run "[CLEAN]" 'sudo apt-get autoremove'
    func_step_run "[CLEAN]" 'sudo apt-get autoclean'
    func_step_run "[CLEAN]" 'sudo apt-get clean'
    func_step_run "[PURGE]" 'func_step_purge'
    func_step_run "[IMAGE]" 'func_step_uninstall_dup_image'
}

# main script entry.
func_main "$@"
