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
################################################################################

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    
    ####### SCRIPT EXECUTION CONFIGURATION #######
    set -euo pipefail
    shopt -s globstar nullglob extglob
    
    ###### PATH ######
    module_apt_sources_switcher_dir="$(
        cd "$(dirname "${BASH_SOURCE[0]}")"
        pwd -P
    )"
    
    ###### IMPORTS ######
    #shellcheck source=/dev/null
    source "${module_apt_sources_switcher_dir}/apt_commands.sh"
    #shellcheck source=/dev/null
    source "${module_apt_sources_switcher_dir}/../common/imports.sh"
fi

###### CONSTANTS ######
declare -gr APT_SOURCES_LIST="/etc/apt/sources.list"
declare -gr ALIYUN_MIRROR_KEY="mirrors.aliyun.com"

func_apt_sources_backup() {
    @func_warn "Backup ${APT_SOURCES_LIST}..."
    
    local target="${APT_SOURCES_LIST}.orig"
    
    sudo cp "${APT_SOURCES_LIST}" "${target}"
    
    @func_warn "Backup ${APT_SOURCES_LIST}...Done."
}

func_apt_sources_switch() {
    
    if @func_file_not_exists "${APT_SOURCES_LIST}"; then
        @func_warn "${APT_SOURCES_LIST} does not exist, touch one."
        sudo touch "${APT_SOURCES_LIST}"
    fi
    
    if @func_file_contains "${APT_SOURCES_LIST}" "${ALIYUN_MIRROR_KEY}"; then
        @func_warn "Already switched to aliyun mirror."
        return 0
    fi
    
    func_apt_sources_backup
    
    @func_warn "Switch to aliyun mirror..."
    
    local ALIYUN_MIRROR="aliyun.sources.list"
    if @func_file_not_exists "${ALIYUN_MIRROR}"; then
        func_apt_sources_format_template "${ALIYUN_MIRROR}"
    fi
    
    sudo cp "${ALIYUN_MIRROR}" "${APT_SOURCES_LIST}"
    
    @func_warn "Switch to aliyun mirror...Done."
    
    func_apt_get_refresh
    
    return 0
}

func_apt_sources_format_template() {
    cat >"$1" <<EOF
deb http://mirrors.aliyun.com/ubuntu/ jammy main restricted universe multiverse
#deb-src http://mirrors.aliyun.com/ubuntu/ jammy main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ jammy-security main restricted universe multiverse
#deb-src http://mirrors.aliyun.com/ubuntu/ jammy-security main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ jammy-updates main restricted universe multiverse
#deb-src http://mirrors.aliyun.com/ubuntu/ jammy-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ jammy-proposed main restricted universe multiverse
#deb-src http://mirrors.aliyun.com/ubuntu/ jammy-proposed main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ jammy-backports main restricted universe multiverse
#deb-src http://mirrors.aliyun.com/ubuntu/ jammy-backports main restricted universe multiverse
EOF
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    func_apt_sources_switch
fi
