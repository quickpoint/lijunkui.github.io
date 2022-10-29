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
    curr_dir="${PWD##*/}"
    common_dir="${curr_dir}/../common"
    
    ###### IMPORTS ######
    #shellcheck source=/dev/null
    source "${common_dir}/common.sh"
    
    test_sys_now() {
        local now
        now="$(@func_sys_now)"
        
        echo "${now}"
    }
    
    test_sys_now
fi
