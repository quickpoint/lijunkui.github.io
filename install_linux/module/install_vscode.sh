#!/usr/bin/env bash
###########################################################
# @(#) install_vscode.sh
# @author quickpoint
# @version 1.0 2019-07-20
#
###########################################################

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

func_config_vscode_source_list() {
    local target="/etc/apt/sources.list.d/vscode.list"
    
    if @func_file_not_exists "${target}"; then
        sudo touch "${target}"
        echo "deb [arch=amd64] http://packages.microsoft.com/repos/vscode stable main" >>"${target}"
    fi
    
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >microsoft.gpg
    
    sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
    
    func_apt_source_refresh
}

func_install_vscode() {
    declare -r COMMAND="code"
    
    func_has_installed "${COMMAND}" && return
    
    @func_info "Installing ${COMMAND}..."
    
    func_config_vscode_source_list
    
    sudo apt-get install code
    
    @func_info "Installing ${COMMAND}...Done"
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    func_install_vscode
fi