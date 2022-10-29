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
    module_patch_factory_dir="$(
        cd "$(dirname "${BASH_SOURCE[0]}")"
        pwd -P
    )"
    
    ###### IMPORTS ######
    #shellcheck source=/dev/null
    source "${module_patch_factory_dir}/../common/common_str.sh"
fi

func_patch_on_line() {
    local patch="$1"
    local line_no="$2"
    local patch_line="$3"
    local target="$4"
    shift 4
    
    local i=0
    local line=""
    IFS=$'\n'
    while read -r line; do
        i=$((i + 1))
        if ((i == line_no)); then
            echo "${patch_line}" >>"${patch}"
        fi
        echo "${line}" >>"${patch}"
    done <"${target}"
    
    sudo mv "${patch}" "${target}"
}

func_patch_on_key() {
    local patch="$1"
    local key="$2"
    local patch_line="$3"
    local target="$4"
    shift 4
    
    local line=""
    IFS=$'\n'
    while read -r line; do
        echo "${line}" >>"${patch}"
        if @func_str_regex_like "${line}" "${key}"; then
            echo "${patch_line}" >>"${patch}"
        fi
    done <"${target}"
    
    sudo mv "${patch}" "${target}"
}

func_patch_if_not_exists() {
    local file="$1"
    local key="$2"
    local value="$3"
    shift 3
    
    if @func_file_not_exists "${file}"; then
        @func_warn "configure ${file} does not exists."
        return 1
    fi
    
    if @func_file_contains "${file}" "${key}"; then
        @func_warn "${key} has already configed in the ${file}."
        return 0
    fi
    
    func_patch_key_value  "${file}" "${key}" "${value}"
}

func_patch_key_value() {
    local file="$1"
    local key="$2"
    local value="$3"
    shift 3
    
    echo "${value}" >>"${file}"
    echo "export PATH=\$PATH:\$${key}" >>"${file}"
    
    #shellcheck source=/dev/null
    source "${file}"
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    echo "patch_factory"
fi
