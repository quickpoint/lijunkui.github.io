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
