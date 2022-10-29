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

    local force=""

    if (($# == 1)); then
        force="$1"
        shift
    fi

    func_install_pip3_if_not_exists "${force}"
    func_install_pip3_packages "${force}"
    func_install_pip3_softwares "${force}"
    func_install_poetry "${force}"
}

func_install_pip3_if_not_exists() {
    local force="$1"
    shift

    declare -r COMMAND="pip3"
    declare -r SOFTWARE="python3-pip"
    
    if func_has_not_installed "${COMMAND}" "${force}"; then
        func_apt_install "${SOFTWARE}"
    fi
}

func_install_pip3_packages() {

    local force="$1"
    shift

    declare -a PIP3_PACKAGES=(
        pandas
        numpy
        matplotlib
        scipy
        sklearn
    )
    
    for each in "${PIP3_PACKAGES[@]}" "${force}"; do
        func_pip3_install "${each}"
    done
}

func_install_pip3_softwares() {

    local force="$1"
    shift 

    declare -a PIP3_SOFTWARES=(
        jupyter
        black
        autopep8
        isort
        pytest
        pylint
        flake8
        mypy
    )
    
    for each in "${PIP3_SOFTWARES[@]}"; do       
        if func_has_not_installed "${each}" "${force}"; then
            func_pip3_install "${each}"
        fi
    done
}

func_install_poetry() {
    local force="$1"
    shift

    declare -r COMMAND="poetry"
    
    func_has_installed "${COMMAND}" "${force}" && return
    
    @func_info "Installing ${COMMAND}..."
    curl -sSL https://install.python-poetry.org | python3 -
    @func_info "Installing ${COMMAND}...Done"
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    func_install_python_related "-y"
fi
