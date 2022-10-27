#!/usr/bin/env bash
###########################################################
# @(#) install_fonts.sh
# @author quickpoint
# @version 1.0 2019-07-20
#
###########################################################
set -euo pipefail
shopt -s globstar nullglob extglob

###### PATH ######
module_install_fonts_dir="$(
    cd "$(dirname "${BASH_SOURCE[0]}")"
    pwd -P
)"

#shellcheck source=/dev/null
source "${module_install_fonts_dir}/install_base.sh"

func_install_fonts() {
    @func_info "Instaling fonts..."

    func_install_tools "ttf-wqy-microhei" "ttf-wqy-zenhei" "xfonts-wqy"

    @func_info "Installing fonts...Done"
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    func_install_fonts
fi
