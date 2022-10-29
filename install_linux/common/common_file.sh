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
    
    ###### PATH ######
    common_common_file_dir="$(
        cd "$(dirname "${BASH_SOURCE[0]}")"
        pwd -P
    )"
    
    ###### IMPORTS ######
    #shellcheck source=/dev/null
    source "${common_common_file_dir}/common_echo.sh"
    
    #shellcheck source=/dev/null
    source "${common_common_file_dir}/common_str.sh"
fi

# does file exist?
# $1) file name
@func_file_exists() {
    (($# != 1)) && {
        @func_error "${FUNCNAME[0]}: <filename>"
        exit 1
    }
    
    local file="$1"
    shift
    
    [[ -f "${file}" ]]
}
export -f @func_file_exists

# does file not exist?
# $1) file name
@func_file_not_exists() {
    ! @func_file_exists "$@"
}
export -f @func_file_not_exists

# is file readable?
# $1) file name
@func_file_is_readable() {
    (($# != 1)) && {
        @func_error "${FUNCNAME[0]}: <filename>"
        exit 1
    }
    
    local file="$1"
    shift
    
    [[ -r "${file}" ]]
}
export -f @func_file_is_readable

# is file writable?
# $1) file name
@func_file_is_writable() {
    (($# != 1)) && {
        @func_error "${FUNCNAME[0]}: <filename>"
        exit 1
    }
    
    local file="$1"
    shift
    
    [[ -w "${file}" ]]
}
export -f @func_file_is_writable

# is file executable?
# $1) file name
@func_file_is_executable() {
    (($# != 1)) && {
        @func_error "${FUNCNAME[0]}: <filename>"
        exit 1
    }
    
    local file="$1"
    shift
    
    [[ -x "${file}" ]]
}
export -f @func_file_is_executable

# file size
# $1) file name
@func_file_size() {
    (($# != 1)) && {
        @func_error "${FUNCNAME[0]}: <filename>"
        exit 1
    }
    
    local filename="$1"
    shift
    
    local file_sz
    if @func_sys_is_mac_os; then
        file_sz="$(stat -f "%p" "${filename}")"
        elif @func_sys_is_linux_os; then
        file_sz="$(stat -c %s "${filename}")"
    else
        file_sz="$(stat -c %s "${filename}")"
    fi
    
    echo "${file_sz}"
}
export -f @func_file_size

# digesting file contents
# $1) path to file
@func_file_digest() {
    (($# != 1)) && {
        @func_error "${FUNCNAME[0]}: <path_to_file>"
        exit 1
    }
    
    local path_to_file="$1"
    shift
    
    local file_digest
    
    if @func_sys_is_mac_os; then
        file_digest="$(md5 -q "${path_to_file}")"
        elif @func_sys_is_linux_os; then
        file_digest="$(md5sum "${path_to_file}" | cut -d " " -f 1)"
    else
        file_digest="$(md5sum "${path_to_file}" | cut -d " " -f 1)"
    fi
    
    echo "${file_digest}"
}
export -f @func_file_digest

# file extent name
# $1) file name
@func_file_name_ext() {
    (($# != 1)) && {
        @func_error "${FUNCNAME[0]}: <file_name>"
        exit 1
    }
    
    local filefullname="$1"
    shift
    
    filefullname="$(@func_file_full_name "${filefullname}")"
    
    local ext
    ext="${filefullname##*.}"
    
    echo "${ext}"
}
export -f @func_file_name_ext

# gets file name without ext
# $1) file name
@func_file_name_without_ext() {
    (($# != 1)) && {
        @func_error "${FUNCNAME[0]}: <file_name>"
        exit 1
    }
    
    local filefullname="$1"
    shift
    
    filefullname="$(@func_file_full_name "${filefullname}")"
    
    local filename="${filefullname%.*}"
    
    echo "${filename}"
}
export -f @func_file_name_without_ext

# file name
# $1) path to file
@func_file_full_name() {
    (($# != 1)) && {
        @func_error "${FUNCNAME[0]}: <path_to_file>"
        exit 1
    }
    
    local path_to_file="$1"
    shift
    
    basename "${path_to_file}"
}
export -f @func_file_full_name

# copy file
# $1) file from
# S2) file to
@func_file_copy() {
    (($# != 2)) && {
        @func_error "${FUNCNAME[0]}: <file_from> <file_to>"
        exit 1
    }
    
    local file_from="$1"
    local file_to="$2"
    shift 2
    
    if @func_file_not_exists "${file_from}"; then
        @func_error "${file_from} does not exist, terminate."
        exit 1
    fi
    
    if @func_file_exists "${file_to}"; then
        @func_error "${file_to} already exists, terminate."
        exit 1
    fi
    
    cp "${file_from}" "${file_to}" 1>/dev/null 2>&1
    return 0
}
export -f @func_file_copy

# file size
# $1) file
@func_file_size() {
    (($# != 1)) && {
        @func_error "${FUNCNAME[0]}: <file>"
        exit 1
    }
    
    local file="$1"
    shift
    
    wc -l "${file}" | awk '{print $1}'
}
export -f @func_file_size

# Does file contain keywords?
# $1) file
# $2) keywords
@func_file_contains() {
    (($# != 2)) && {
        @func_error "${FUNCNAME[0]}: <file> <keywords>"
        exit 1
    }
    
    if grep -q "$2" "$1"; then
        return 0
    else
        return 1
    fi
}
export -f @func_file_contains

# Does file not contain keywords?
# $1) file
# $2) keywords
@func_file_not_contains() {
    ! @func_file_contains "$@"
}
export -f @func_file_not_contains

@func_file_real_execute_path() {
    
    local command="$1"
    
    local whichone
    whichone="$(which "${command}")"
    
    readlink -f "${whichone}"
}
export -f @func_file_real_execute_path

# ----------------------------

# does directory exist?
# $1) directory path
@func_dir_exists() {
    (($# != 1)) && {
        @func_error "${FUNCNAME[0]}: <dirpath>"
        exit 1
    }
    
    local dir="$1"
    shift
    
    [[ -d "${dir}" ]]
}
export -f @func_dir_exists

# does directory not exist?
# $1) directory path
@func_dir_not_exists() {
    ! @func_dir_exists "$@"
}
export -f @func_dir_not_exists

# dir name
# $1) path to file
@func_dir_name() {
    (($# != 1)) && {
        @func_error "${FUNCNAME[0]}: <path_to_file>"
        exit 1
    }
    
    local path_to_file="$1"
    shift
    
    dirname "${path_to_file}"
}
export -f @func_dir_name
