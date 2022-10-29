#!/usr/bin/env bash
#
# @author: quickpoint
# @version: 1.0
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
fi

## @func_color_echo
## @param color color for the echo text
## @param prefix prefox for the echo text
## @param text text for echo
@func_color_echo() {
    if (($# != 3)); then
        echo -e "${FUNCNAME[0]}: <color>  <prefix> <text>."
        exit 1
    fi
    
    local color="$1"
    local prefix="$2"
    shift 2
    local text="$*"
    
    local COLOR_BEGIN="\033[1;"
    local COLOR_END="\033[0m"
    
    echo -e "${COLOR_BEGIN}${color}m${prefix} ${text}${COLOR_END}"
}
export -f @func_color_echo

## @func_info
@func_info() {
    local GREEN=32
    @func_color_echo "${GREEN}" "[INFO]" "$*"
}
export -f @func_info

## @func_warn
@func_warn() {
    local YELLOW=33
    @func_color_echo "${YELLOW}" "[WARN]" "$*"
}
export -f @func_warn

## @func_error
@func_error() {
    local RED=31
    @func_color_echo "${RED}" "[ERROR]" "$*"
}
export -f @func_error
