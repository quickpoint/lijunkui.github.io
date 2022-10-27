#!/usr/bin/env bash
#
# @(#) imports.sh
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
