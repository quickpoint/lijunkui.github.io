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
fi

#;
# @func_sys_is_mac_os()
# Is the sys is a MAC os?
# @return true if yes, return false if no
#"
@func_sys_is_mac_os() {
    [[ "${OSTYPE}" = "darwin"* ]]
}
export -f @func_sys_is_mac_os

#;
# @func_sys_is_windows_os()
# Is the sys is a windows os?
# @return true if yes, return false if no
#"
@func_sys_is_windows_os() {
    [[ "${OSTYPE}" = "cygwin" ]] || [[ "${OSTYPE}" = "msys" ]]
}
export -f @func_sys_is_windows_os

#;
# @func_sys_is_linux_os()
# Is the sys is a linux os?
# @return true if yes, return false if no
#"
@func_sys_is_linux_os() {
    [[ "${OSTYPE}" = "linux-gnu" ]]
}
export -f @func_sys_is_linux_os

#;
# @func_sys_now()
# Gets the system now time, in the form of YYYY-MM-DD HH:mm:ss.
# @return time in string form
#"
@func_sys_now() {
    local now
    
    now="$(date "+%Y-%m-%d %H:%M:%S")"
    
    echo "${now}"
}
export -f @func_sys_now

#;
# @func_sys_update()
# Updates the system.
#"
@func_sys_update() {
    if @func_sys_is_mac_os; then
        brew update
    else
        sudo apt-get update
    fi
}
export -f @func_sys_update

#;
# @func_sys_upgrade()
# Upgrade the system.
#"
@func_sys_upgrade() {
    if @func_sys_is_mac_os; then
        brew upgrade
    else
        sudo apt-get upgrade -y
    fi
}
export -f @func_sys_upgrade

#;
# @func_sys_dist_upgrade()
# Upgrades the dist.
#"
@func_sys_dist_upgrade() {
    if @func_sys_is_mac_os; then
        brew upgrade
    else
        sudo apt-get -y dist-upgrade
    fi
}
export -f @func_sys_dist_upgrade

#;
# @func_sys_clean()
# Cleans up the system, removes all the redundant.
#"
@func_sys_clean() {
    if @func_sys_is_mac_os; then
        brew cleanup --force -s
    else
        sudo apt-get -y autoclean
        sudo apt-get -y autoremove
        sudo apt-get -y clean
    fi
}
export -f @func_sys_clean


@func_sys_install() {
    if @func_sys_is_mac_os; then
        brew install "$@"
    else
        sudo apt-get -y install "$@"
    fi
}
export -f @func_sys_install

@func_sys_purge() {
    if @func_sys_is_mac_os; then
        brew uninstall "$@"
    else
        sudo apt-get -y remove --purge "$@"
    fi
}
export -f @func_sys_purge
