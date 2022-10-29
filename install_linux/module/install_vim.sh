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

func_install_spacevim() {
    curl -sLf https://spacevim.org/cn/install.sh | bash
}

func_install_vim() {
    
    local force=""
    
    if (($# == 1)); then
        force="$1"
        shift
    fi
    
    declare -r COMMAND="vim"
    
    func_has_installed "${COMMAND}" "${force}" && return
    
    @func_info "Installing ${COMMAND}..."
    
    func_install_tools 'vim' 'neovim'
    
    func_step_run "[INSTALL SPACEVIM]" 'func_install_spacevim'
    
    @func_info "intalling ${COMMAND}...Done"
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    func_install_vim "-y"
fi
