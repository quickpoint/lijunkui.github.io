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
module_imports_dir="$(
    cd "$(dirname "${BASH_SOURCE[0]}")"
    pwd -P
)"

###### IMPORTS ######
#shellcheck source=/dev/null
source "${module_imports_dir}/apt_commands.sh"

#shellcheck source=/dev/null
source "${module_imports_dir}/apt_sources_switcher.sh"

#shellcheck source=/dev/null
source "${module_imports_dir}/config.sh"

#shellcheck source=/dev/null
source "${module_imports_dir}/install_base.sh"

#shellcheck source=/dev/null
source "${module_imports_dir}/install_fonts.sh"

#shellcheck source=/dev/null
source "${module_imports_dir}/install_input_method.sh"

#shellcheck source=/dev/null
source "${module_imports_dir}/patch_factory.sh"
