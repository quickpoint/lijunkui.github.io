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
fi

###### PATH ######
module_imports_dir="$(
    cd "$(dirname "${BASH_SOURCE[0]}")"
    pwd -P
)"

###### IMPORTS ######
#shellcheck source=/dev/null
source "${module_imports_dir}/../common/imports.sh"

#shellcheck source=/dev/null
source "${module_imports_dir}/apt_commands.sh"

#shellcheck source=/dev/null
source "${module_imports_dir}/apt_sources_switch.sh"

#shellcheck source=/dev/null
source "${module_imports_dir}/install_and_config_java.sh"

#shellcheck source=/dev/null
source "${module_imports_dir}/install_and_config_maven.sh"

#shellcheck source=/dev/null
source "${module_imports_dir}/install_apt_softwares.sh"

#shellcheck source=/dev/null
source "${module_imports_dir}/install_base.sh"

#shellcheck source=/dev/null
source "${module_imports_dir}/install_fonts.sh"

#shellcheck source=/dev/null
source "${module_imports_dir}/install_google_chrome.sh"

#shellcheck source=/dev/null
source "${module_imports_dir}/install_input_method.sh"

#shellcheck source=/dev/null
source "${module_imports_dir}/install_python_related.sh"

#shellcheck source=/dev/null
source "${module_imports_dir}/install_snap_softwares.sh"

#shellcheck source=/dev/null
source "${module_imports_dir}/install_vim.sh"

#shellcheck source=/dev/null
source "${module_imports_dir}/install_vscode.sh"

#shellcheck source=/dev/null
source "${module_imports_dir}/patch_factory.sh"

#shellcheck source=/dev/null
source "${module_imports_dir}/install_deb_softwares.sh"
