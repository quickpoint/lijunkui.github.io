#!/usr/bin/env bash
###########################################################
# @(#) install_and_config_java.sh
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

func_install_and_config_java() {
    declare -r COMMAND="java"
    
    func_has_installed "${COMMAND}" && return
    
    func_step_run "[INSTALL JAVA]" 'func_install_java'
    
    func_step_run "[CONFIG JAVA_HOME]" 'func_config_java'
}

func_install_java() {
    
    declare -r COMMAND="java"
    
    declare -a PACKAGES=(default-jdk default-jdk-doc)
    
    for each in "${PACKAGES[@]}"; do
        func_apt_install "${each}"
    done
}

func_config_java() {
    local real_path
    real_path="$(@func_file_real_execute_path "java")"
    
    local home_path
    home_path="$(dirname "${real_path}")"
    
    local line="export JAVA_HOME=${home_path}"
    
    func_patch_if_not_exists "${HOME}/.profile" "JAVA_HOME" "${line}"
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    func_install_and_config_java
fi
