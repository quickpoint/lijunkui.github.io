#!/usr/bin/env bash
###########################################################
# @(#) install_apt_softwares.sh
# @author quickpoint
# @version 1.0 2019-07-20
#
###########################################################

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

func_install_apt_softwares() {
    declare -a TOOLS=(git curl snap)
    
    for each in "${TOOLS[@]}"; do
        
        if func_has_installed "${each}"; then
            continue
        fi
        
        func_apt_install "${each}"
    done
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    func_install_apt_softwares
fi