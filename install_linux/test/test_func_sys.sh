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

###### PATH ######
curr_dir="$(
    cd "$(dirname "${BASH_SOURCE[0]}")"
    pwd -P
)"
module_dir="${curr_dir}/../module"

###### IMPORTS ######
#shellcheck source=/dev/null
source "${module_dir}/common.sh"

test_sys_now() {
    local now
    now="$(@func_sys_now)"

    echo "${now}"
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    test_sys_now
fi
