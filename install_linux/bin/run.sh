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
    bin_run_dir="$(
        cd "$(dirname "${BASH_SOURCE[0]}")"
        pwd -P
    )"
    
    ###### IMPORTS ######
    #shellcheck source=/dev/null
    source "${bin_run_dir}/../module/imports.sh"
    
    func_main() {

        # local force="-y"
        local force="-n"

        if (($# == 1)); then
            force="$1"
            shift
        fi

        func_step_run "[APT REFRSH]" "func_apt_get_refresh"
        #func_step_run "[APT SWITCH]" "func_apt_sources_switch"
        func_step_run "[INSTALL TOOLS]" "func_install_apt_softwares" "${force}" 
        func_step_run "[INSTALL VIM]" "func_install_vim" "${force}"
        func_step_run "[INSTALL CHROME]" "func_install_google_chrome" "${force}"
        func_step_run "[INSTALL VSCODE]" "func_install_vscode" "${force}"
        func_step_run "[INSTALL IM]" "func_install_input_method" "${force}"
        func_step_run "[INSTALL DEB]" "func_install_deb_software" "${force}"
        func_step_run "[INSTALL FONTS]" "func_install_fonts" "${force}"
        
        func_step_run "[INSTALL JAVA]" "func_install_and_config_java" "${force}"   
        func_step_run "[INSTALL MAVEN]" "func_install_and_config_maven" "${force}"
        func_step_run "[INSTALL PYTHON]" "func_install_python_related" "${force}"
        func_step_run "[INSTALL SNAP_SOFTWARES]" "func_install_snap_softwares" "${force}"
    }
    
    # the script main entry.
    func_main "$@"
fi
