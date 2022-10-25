#!/usr/bin/env bash
###########################################################
# @(#) install_input_method.sh
# @author quickpoint
# @version 1.0 2019-07-20
#
###########################################################
set -euo pipefail
shopt -s globstar nullglob extglob

###### PATH ######
module_install_input_method_dir="$(
    cd "$(dirname "${BASH_SOURCE[0]}")"
    pwd -P
)"

###### IMPORTS ######
#shellcheck source=/dev/null
source "${module_install_input_method_dir}/../common/common_command.sh"

#shellcheck source=/dev/null
source "${module_install_input_method_dir}/../common/common_echo.sh"

func_install_input_method() {

    declare -r COMMAND="fcitx"

    func_pre_install_check "${COMMAND}" && return

    @func_info "Installing ${COMMAND}..."

    sudo apt-get install fcitx fcitx-googlepinyin im-config

    @func_info "Installing ${COMMAND}...Done"
}
