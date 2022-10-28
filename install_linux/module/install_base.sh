#!/usr/bin/env bash
###########################################################
# @(#) install_base.sh
# @author quickpoint
# @version 1.0 2019-07-20
#
###########################################################

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    
    ####### SCRIPT EXECUTION CONFIGURATION #######
    set -euo pipefail
    shopt -s globstar nullglob extglob
    
    ###### PATH ######
    module_install_base_dir="$(
        cd "$(dirname "${BASH_SOURCE[0]}")"
        pwd -P
    )"
    
    ###### IMPORTS ######
    #shellcheck source=/dev/null
    source "${module_install_base_dir}/../common/common_command.sh"
    
    #shellcheck source=/dev/null
    source "${module_install_base_dir}/../common/common_echo.sh"
fi

func_has_installed() {
    local command="$1"
    
    if @func_command_in_path "${command}"; then
        @func_warn "${command} has already been installed."
        return 0
    fi
    
    return 1
}

func_step_run() {
    if (($# != 2)); then
        @func_error "${FUNCNAME[0]} <declare><cmd>"
        exit 1
    fi
    
    local declare="$1"
    shift
    local cmd="$*"
    
    @func_warn "---------------${declare}---------------"
    ${cmd}
}

func_install_tools() {
    for each in "$@"; do
        func_apt_install "${each}"
    done
}

func_apt_install() {
    local software="$1"
    shift
    
    @func_info "Installing ${software}..."
    sudo apt-get install -y "${software}"
    @func_info "Installing ${software}...Done"
}

func_dpkg_install_tools() {
    for each in "$@"; do
        func_dpkg_install "${each}"
    done
}

func_dpkg_install() {
    local software="$1"
    shift
    
    @func_info "Installing ${software}..."
    sudo dpkg -i "${software}"
    @func_info "Installing ${software}...Done"
}

func_pip3_install_tools() {
    for each in "$@"; do
        func_pip3_install "${each}"
    done
}

func_pip3_install() {
    local software="$1"
    shift
    
    @func_info "Installing ${software}..."
    pip3 install "${software}"
    @func_info "Installing ${software}...Done"
}

func_snap_install_tools() {
    for each in "$@"; do
        func_snap_install "${each}"
    done
}

func_snap_install() {
    local software="$1"
    shift
    
    @func_info "Installing ${software}..."
    sudo snap install "${software}" --classic
    @func_info "Installing ${software}...Done"
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    test_has_installed() {
        declare -r COMMAND="wps"
        
        echo "$(func_has_installed "${COMMAND}")"
    }
    
    test_has_installed
fi
