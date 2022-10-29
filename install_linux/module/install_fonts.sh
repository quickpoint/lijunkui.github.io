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
    module_install_fonts_dir="$(
        cd "$(dirname "${BASH_SOURCE[0]}")"
        pwd -P
    )"
    
    #shellcheck source=/dev/null
    source "${module_install_fonts_dir}/install_base.sh"
fi

func_install_fonts() {
    @func_info "Instaling fonts..."
    
    func_install_tools "fonts-wqy-microhei" "fonts-wqy-zenhei" "xfonts-wqy"
    
    @func_info "Installing fonts...Done"
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    func_install_fonts
fi
