#!/usr/bin/env bash
###########################################################
# @(#) install_python_related.sh
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

func_install_python_related() {
    declare -r COMMAND="pip3"
    
    func_has_installed "${COMMAND}" && return
    
    declare -a PACKAGES=(python3-pip)
    
    for each in "${PACKAGES[@]}"; do
        func_apt_install "${each}"
    done
    
    declare -a PIP3_PACKAGES=(pandas numpy matplotlib scipy sklearn
    jupyter black autopep8 isort pytest pylint flake8 mypy)
    
    for each in "${PIP3_PACKAGES[@]}"; do
        func_pip3_install "${each}"
    done
    
    func_step_run "[INSTALL POETRY]" 'func_install_poetry'
}

func_install_poetry() {
    declare -r COMMAND="poetry"
    
    func_has_installed "${COMMAND}" && return
    
    @func_info "Installing ${COMMAND}..."
    curl -sSL https://install.python-poetry.org | python3 -
    @func_info "Installing ${COMMAND}...Done"
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    func_install_python_related
fi