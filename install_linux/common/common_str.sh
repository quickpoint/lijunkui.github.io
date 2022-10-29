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
    common_common_str_dir="$(
        cd "$(dirname "${BASH_SOURCE[0]}")"
        pwd -P
    )"
    
    ###### IMPORTS ######
    #shellcheck source=/dev/null
    source "${common_common_str_dir}/common_echo.sh"
fi

# is string empty?
# $1) string
@func_str_is_empty() {
    (($# != 1)) && {
        @func_error "${FUNCNAME[0]}: <string>"
        exit 1
    }
    
    local var="$1"
    shift
    
    [[ -z "${var}" ]]
}
export -f @func_str_is_empty

# is string not empty?
# $1) string
@func_str_is_not_empty() {
    (($# != 1)) && {
        @func_error "${FUNCNAME[0]}: <string>"
        exit 1
    }
    
    local var="$1"
    shift
    
    [[ -n "${var}" ]]
}
export -f @func_str_is_not_empty

# trim the string
# $1) string
@func_str_trim() {
    (($# != 1)) && {
        @func_error "${FUNCNAME[0]}: <string>"
        exit 1
    }
    
    : "${1#"${1%%[![:space:]]*}"}"
    : "${_%"${_##*[![:space:]]}"}"
    printf '%s\n' "$_"
    
    return 0
}
export -f @func_str_trim

# does the two strings equal to each other?
# $1) string 1
# $2) string 2
@func_str_equals() {
    (($# != 2)) && {
        @func_error "${FUNCNAME[0]}: <string1> <string2>"
        exit 1
    }
    
    [[ "$1" == "$2" ]]
}
export -f @func_str_equals

# does string start with sub_string?
# $1) string
# $2) sub_string
@func_str_starts() {
    (($# != 2)) && {
        @func_error "${FUNCNAME[0]}: <string> <substring>"
        exit 1
    }
    
    local var="$1"
    local sub_string="$2"
    shift 2
    
    [[ "${var}" == "${sub_string}"* ]]
}
export -f @func_str_starts

# does string end with sub_string?
# $1) string
# $2) sub_string
@func_str_ends() {
    (($# != 2)) && {
        @func_error "${FUNCNAME[0]}: <string> <substring>"
        exit 1
    }
    
    local var="$1"
    local sub_string="$2"
    shift 2
    
    [[ "${var}" == *"${sub_string}" ]]
}
export -f @func_str_ends

# is string like a regex?
# $1) string
# $2) regex
@func_str_regex_like() {
    (($# != 2)) && {
        @func_error "${FUNCNAME[0]}: <string> <regex>"
        exit 1
    }
    
    local var="$1"
    local regex="$2"
    shift 2
    
    [[ "${var}" =~ ${regex} ]]
}
export -f @func_str_regex_like
