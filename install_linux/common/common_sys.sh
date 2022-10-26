#!/usr/bin/env bash
#
# @(#) common_sys.sh
#
# @author: quickpoint
# @version: 1.0 2022-10-11
#
# Copyright (c) 2008-2022, quickpoint.
#
# "THE FRIED-DUMPLING-WARE LICENSE", Version 1.0:
# Quickpoint wrote this file.  As long as you retain this notice you
# can do whatever you want with this stuff. If we meet some day, and you think
# this stuff is worth it, you can buy me a fried-dumpling in return.
#
################################################################################

####### SCRIPT EXECUTION CONFIGURATION #######
set -euo pipefail
shopt -s globstar nullglob extglob

@func_sys_is_mac_os() {
    [[ "${OSTYPE}" = "darwin"* ]]
}
export -f @func_sys_is_mac_os

@func_sys_is_windows_os() {
    [[ "${OSTYPE}" = "cygwin" ]] || [[ "${OSTYPE}" = "msys" ]]
}
export -f @func_sys_is_windows_os

@func_sys_is_linux_os() {
    [[ "${OSTYPE}" = "linux-gnu" ]]
}
export -f @func_sys_is_linux_os

@func_sys_now() {
    local now

    now="$(date "+%Y-%m-%d %H:%M:%S")"

    echo "${now}"
}
export -f @func_sys_now
