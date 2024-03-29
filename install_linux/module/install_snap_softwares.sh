#!/usr/bin/env bash
#
# @author quickpoint
# @version 1.0
#
# Copyright (c) 2008-2022, quickpoint.
#
# "THE FRIED-DUMPLING-WARE LICENSE", Version 1.0:
# Quickpoint wrote this file.  As long as you retain this notice you
# can do whatever you want with this stuff. If we meet some day, and you think
# this stuff is worth it, you can buy me a fried-dumpling in return.
#

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    
    ####### SCRIPT EXECUTION CONFIGURATION #######
    set -euo pipefail
    shopt -s globstar nullglob extglob
    
    ###### PATH ######
    module_config_dir="$(
        cd "$(dirname "${BASH_SOURCE[0]}")"
        pwd -P
    )"
    
    ###### IMPORTS ######
    #shellcheck source=/dev/null
    source "${module_config_dir}/../common/imports.sh"
    
    #shellcheck source=/dev/null
    source "${module_config_dir}/install_base.sh"
fi

func_install_snap_softwares() {
    
    local force="$1"
    shift

    declare -r SNAP="snap"
    
    if func_has_not_installed "${SNAP}" "${force}"; then
        func_apt_install "${SNAP}"
    fi
    
    declare -a TOOLS=(
        intellij-idea-community
        pycharm-community
    )
    
    for each in "${TOOLS[@]}"; do
        
        if func_has_installed "${each}" "${force}"; then
            continue
        fi
        
        func_snap_install "${each}"
    done
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    func_install_snap_softwares "-y"
fi
