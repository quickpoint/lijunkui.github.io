#!/usr/bin/env bash
###########################################################
# @(#) apt_commands.sh
# @author quickpoint
# @version 1.0 2019-07-20
#
###########################################################
set -euo pipefail
shopt -s globstar nullglob extglob

###### PATH ######
curr_dir="$(
    cd "$(dirname "${BASH_SOURCE[0]}")"
    pwd -P
)"

###### IMPORTS ######
#shellcheck source=/dev/null
source "${curr_dir}/common.sh"

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

func_apt_get_update() {
    func_step_run "[UPDATE]" 'sudo apt-get update'
}

func_apt_get_upgrade() {
    func_step_run "[UPDATE]" 'sudo apt-get upgrade -y'
}

func_apt_get_dist_upgrade() {
    func_step_run "[DIST-UPDATE]" 'sudo apt-get dist-upgrade -y'
}

func_apt_get_auto_remove() {
    func_step_run "[CLEAN]" 'sudo apt-get autoremove'
}

func_apt_get_auto_clean() {
    func_step_run "[CLEAN]" 'sudo apt-get autoclean'
}

func_apt_get_clean() {
    func_step_run "[CLEAN]" 'sudo apt-get clean'
}

func_apt_get_purge() {
    func_step_run "[PURGE]" 'func_apt_get_do_purge'
}

func_apt_get_do_purge() {
    sudo deborphan | xargs sudo apt-get -y remove --purge
}

func_apt_get_uninstall_dup_images() {
    func_step_run "[IMAGE]" 'func_apt_get_do_uninstall_dup_images'
}

func_apt_get_do_uninstall_dup_images() {

    sudo dpkg --get-selections \
        | grep "deinstall" \
        | sed 's/deinstall/\lpurge/' \
        | sudo dpkg --set-selections \
        && sudo dpkg -Pa
    
    return 0
}

func_apt_get_refresh() {
    declare -a COMMANDS=(
        func_apt_get_update
        func_apt_get_upgrade
        func_apt_get_dist_upgrade
        func_apt_get_auto_remove
        func_apt_get_auto_clean
        func_apt_get_clean
        func_apt_get_purge
        func_apt_get_uninstall_dup_images
    )

    for each in "${COMMANDS[@]}"; do
        ${each}
    done
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    func_apt_get_refresh
fi
