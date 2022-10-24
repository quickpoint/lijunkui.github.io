#!/usr/bin/env bash
#
# @(#) common.sh
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

# ----------------------------
@func_error_exit() {
    local JOB="$0"      # job name
    local LASTLINE="$1" # line of error occurrence
    local LASTERR="$2"  # error code
    shift 2

    echo -e "ERROR in ${JOB} : line ${LASTLINE} with exit code ${LASTERR}"
}
trap '@func_error_exit ${LINENO} ${?}' ERR

# ----------------------------

@func_is_mac_os() {
    [[ "${OSTYPE}" = "darwin"* ]]
}
export -f @func_is_mac_os

@func_is_windows_os() {
    [[ "${OSTYPE}" = "cygwin" ]] || [[ "${OSTYPE}" = "msys" ]]
}
export -f @func_is_windows_os

@func_is_linux_os() {
    [[ "${OSTYPE}" = "linux-gnu" ]]
}
export -f @func_is_linux_os

# ----------------------------
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

# ----------------------------

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

# ----------------------------

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
    if @func_is_mac_os; then
        file_sz="$(stat -f "%p" "${filename}")"
    elif @func_is_linux_os; then
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

    if @func_is_mac_os; then
        file_digest="$(md5 -q "${path_to_file}")"
    elif @func_is_linux_os; then
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
    whichone="$(which ${command})"

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

# ----------------------------

declare -g CACHE=()
# cache add
# $1) path to file
@func_cache_add() {
    CACHE[${#CACHE[@]}]="$1"
}
export -f @func_cache_add

# destroy the cache
# Removes all the files in the cache if the file exists.
@func_cache_destroy() {
    local file
    for file in "${CACHE[@]}"; do
        if @func_file_exists "${file:?}"; then
            rm -rf "${file:?}"
        fi
    done

    unset CACHE
}
trap '@func_cache_destroy' EXIT

@func_sys_now() {
    local now

    now="$(date "+%Y-%m-%d %H:%M:%S")"

    echo "${now}"
}
export -f @func_sys_now

@func_command_in_path() {
    command -v "$@"
}
export -f @func_command_in_path

@func_command_not_in_path() {
    ! @func_command_in_path "$@"
}
export -f @func_command_not_in_path
