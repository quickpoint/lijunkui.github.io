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
    common_common_trap_dir="$(
        cd "$(dirname "${BASH_SOURCE[0]}")"
        pwd -P
    )"
    
    ###### IMPORTS ######
    #shellcheck source=/dev/null
    source "${common_common_trap_dir}/common_file.sh"
fi

@func_error_exit() {
    local JOB="$0"      # job name
    local LASTLINE="$1" # line of error occurrence
    local LASTERR="$2"  # error code
    shift 2
    
    echo -e "ERROR in ${JOB} : line ${LASTLINE} with exit code ${LASTERR}"
}
trap '@func_error_exit ${LINENO} ${?}' ERR

@func_die() {
    ret=$?
    if [ "$ret" != "0" ];then
        @func_error "in $0, with exit code ${ret}, traceback:";
        local i=0
        local size=${#FUNCNAME[@]}
        local sep=" "
        for ((i=1; i < size; i++)); do
            @func_error "${sep}" "func: ${FUNCNAME[$i]}" " line:${BASH_LINENO[$((i-1))]}"
        done
        
        exit $ret;
    fi
}
export -f @func_die

declare -g FILE_CACHE=()
# cache add
# $1) path to file
@func_file_cache_add() {
    FILE_CACHE[${#FILE_CACHE[@]}]="$1"
}
export -f @func_file_cache_add

# destroy the cache
# Removes all the files in the cache if the file exists.
@func_file_cache_destroy() {
    local file
    for file in "${FILE_CACHE[@]}"; do
        if @func_file_exists "${file:?}"; then
            rm -rf "${file:?}"
        fi
    done
    
    unset FILE_CACHE
}
export -f @func_file_cache_destroy
trap '@func_file_cache_destroy' EXIT
