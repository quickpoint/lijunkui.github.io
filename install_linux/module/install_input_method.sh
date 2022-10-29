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
################################################################################

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    
    ####### SCRIPT EXECUTION CONFIGURATION #######
    set -euo pipefail
    shopt -s globstar nullglob extglob
    
    ###### PATH ######
    module_install_input_method_dir="$(
        cd "$(dirname "${BASH_SOURCE[0]}")"
        pwd -P
    )"
    
    ###### IMPORTS ######
    #shellcheck source=/dev/null
    source "${module_install_input_method_dir}/../common/common_command.sh"
    
    #shellcheck source=/dev/null
    source "${module_install_input_method_dir}/../common/common_echo.sh"
fi

func_install_input_method() {
    declare -r COMMAND="fcitx"
    
    func_has_installed "${COMMAND}" && return
    
    @func_info "Installing ${COMMAND}..."
    
    sudo apt-get install fcitx fcitx-googlepinyin im-config
    
    @func_info "Installing ${COMMAND}...Done"
}
