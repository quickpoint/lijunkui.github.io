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
    
    #shellcheck source=/dev/null
    source "${module_config_dir}/patch_factory.sh"
fi

func_install_and_config_maven() {
     local force=""

    if (($# == 1)); then
        force="$1"
        shift
    fi

    declare -r COMMAND="mvn"
    
    func_has_installed "${COMMAND}" "${force}" && return
    
    func_step_run "[INSTALL MAVEN]" 'func_install_maven'
    func_step_run "[CONFIG MAVEN_HOME]" 'func_config_maven_home'
    func_step_run "[CONFIG M2_MIRROR]" 'func_config_maven_mirror'
}

func_install_maven() {
    declare -r COMMAND="mvn"
    
    func_has_installed "${COMMAND}" && return
    
    declare -r SOFTWARE="maven"
    
    func_apt_install "${SOFTWARE}"
}

func_config_maven_home() {
    local real_path
    real_path="$(@func_file_real_execute_path "mvn")"
    
    local home_path
    home_path="$(dirname "${real_path}")"
    
    local line="export MAVEN_HOME=${home_path}"
    func_patch_if_not_exists "${HOME}/.profile" "MAVEN_HOME" "${line}"
}

func_config_maven_mirror() {
    local settings_path="/usr/share/maven/conf/settings.xml"
    local mirror_key="http://maven.aliyun.com/nexus/content/groups/public"
    
    if @func_file_contains "${settings_path}" "${mirror_key}"; then
        @func_warn "${settings_path} has aleady been configed."
        return 0
    fi
    
    local settings_patch="settings_patch"
    local mirror="<mirror>\
    <id>nexus-aliyun</id>\
    <mirrorOf>central</mirrorOf>\
    <name>Nexus aliyun</name>\
    <url>${mirror_key}</url>\
    </mirror>"
    
    func_patch_on_key "${settings_patch}" "<mirrors>" "${mirror}" "${settings_path}"
}
