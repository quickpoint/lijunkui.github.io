#!/usr/bin/env bash
###########################################################
# @(#) install_base.sh
# @author quickpoint
# @version 1.0 2019-07-20
#
###########################################################
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

func_pre_install_check() {
    local COMMAND="$1"

    if @func_command_in_path "${COMMAND}"; then
        @func_warn "${COMMAND} has already been installed."
        return 0
    fi

    return 1
}

func_install_tools() {
    for each in "$@"; do
        func_apt_install "${each}"
    done
}

func_apt_install() {
    local command=""
    local software=""

    if (($# == 1)); then
        command="$1"
        software="$1"
        shift 1
    elif (($# == 2)); then
        command="$1"
        software="$2"
        shift 2
    else
        @func_error "too many parameters."
    fi

    if @func_command_in_path "${command}"; then
        @func_warn "${command} has already been installed."
    else
        @func_info "Installing ${software}..."
        sudo apt-get install -y "${software}"
        @func_info "Installing ${software}...Done"
    fi
}

func_dpkg_install() {
    local command=""
    local software=""

    if (($# == 1)); then
        command="$1"
        software="$1"
        shift 1
    elif (($# == 2)); then
        command="$1"
        software="$2"
        shift 2
    else
        @func_error "too many parameters."
    fi

    if @func_command_in_path "${command}"; then
        @func_warn "${command} has already been installed."
    else
        @func_info "Installing ${software}..."
        sudo dpkg -i "${software}"
        @func_info "Installing ${software}...Done"
    fi
}

func_pip3_install_tools() {
    for each in "$@"; do
        func_pip3_install "${each}"
    done
}

func_pip3_install() {
    local command=""
    local software=""

    if (($# == 1)); then
        command="$1"
        software="$1"
        shift 1
    elif (($# == 2)); then
        command="$1"
        software="$2"
        shift 2
    else
        @func_error "too many parameters."
        return
    fi

    if @func_command_in_path "${command}"; then
        @func_warn "${command} has already been installed."
    else
        @func_info "Installing ${software}..."
        pip3 install "${software}"
        @func_info "Installing ${software}...Done"
    fi
}
