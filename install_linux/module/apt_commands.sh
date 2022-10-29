#!/usr/bin/env bash
###########################################################
# @(#) apt_commands.sh
# @author quickpoint
# @version 1.0 2019-07-20
#
###########################################################

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    ####### SCRIPT EXECUTION CONFIGURATION #######
    set -euo pipefail
    shopt -s globstar nullglob extglob
    
    ###### PATH ######
    module_apt_commands_dir="$(
        cd "$(dirname "${BASH_SOURCE[0]}")"
        pwd -P
    )"
    
    ###### IMPORTS ######
    #shellcheck source=/dev/null
    source "${module_apt_commands_dir}/../common/imports.sh"

    #shellcheck source=/dev/null
    source "${module_apt_commands_dir}/install_base.sh"
fi

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
    
    sudo dpkg --get-selections |
    grep "deinstall" |
    sed 's/deinstall/\lpurge/' |
    sudo dpkg --set-selections &&
    sudo dpkg -Pa
    
    return 0
}

func_apt_get_refresh() {
    declare -a COMMANDS=(
        func_rm_locks_if_exists
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
