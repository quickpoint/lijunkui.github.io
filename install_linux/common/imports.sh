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

###### PATH ######
cmomon_imports_dir="$(
    cd "$(dirname "${BASH_SOURCE[0]}")"
    pwd -P
)"

###### IMPORTS ######
#shellcheck source=/dev/null
source "${cmomon_imports_dir}/common_str.sh"

#shellcheck source=/dev/null
source "${cmomon_imports_dir}/common_file.sh"

#shellcheck source=/dev/null
source "${cmomon_imports_dir}/common_trap.sh"

#shellcheck source=/dev/null
source "${cmomon_imports_dir}/common_sys.sh"

#shellcheck source=/dev/null
source "${cmomon_imports_dir}/common_echo.sh"

#shellcheck source=/dev/null
source "${cmomon_imports_dir}/common_command.sh"
