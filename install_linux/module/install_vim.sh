#!/usr/bin/env bash
###########################################################
# @(#) install_vim.sh
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

func_install_vim() {
    declare -r COMMAND="vim"
    
    func_has_installed "${COMMAND}" && return
    
    @func_info "Installing ${COMMAND}..."
    
    func_install_tools 'vim' 'neovim'

    func_step_run "[INSTALL SPACEVIM]" 'func_install_spacevim'

    @func_info "intalling ${COMMAND}...Done"
}

func_install_spacevim() {
    curl -sLf https://spacevim.org/cn/install.sh | bash
}
