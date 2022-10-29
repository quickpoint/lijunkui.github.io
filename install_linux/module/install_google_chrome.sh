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
    module_install_chrome_dir="$(
        cd "$(dirname "${BASH_SOURCE[0]}")"
        pwd -P
    )"
    
    ###### IMPORTS ######
    #shellcheck source=/dev/null
    source "${module_install_chrome_dir}/../common/imports.sh"
    
    #shellcheck source=/dev/null
    source "${module_install_chrome_dir}/install_base.sh"
    
    #shellcheck source=/dev/null
    source "${module_install_chrome_dir}/apt_commands.sh"
fi

func_config_google_chrome_source_list() {
    sudo wget http://www.linuxidc.com/files/repo/google-chrome.list \
    -P /etc/apt/sources.list.d/
    
    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub |
    sudo apt-key add -
    
    func_apt_get_refresh
}

func_install_google_chrome() {
    declare -r COMMAND="google-chrome"
    
    func_has_installed "${COMMAND}" && return
    
    @func_info "Installing ${COMMAND}..."
    
    func_config_google_chrome_source_list
    
    declare -r SOFTWARE="google-chrome-stable"
    
    func_apt_install "${COMMAND}" "${SOFTWARE}"
    
    @func_info "Installing ${COMMAND}...Done"
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    func_install_google_chrome
fi
