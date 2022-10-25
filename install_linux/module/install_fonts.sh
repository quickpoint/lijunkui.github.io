#!/usr/bin/env bash
###########################################################
# @(#) install_fonts.sh
# @author quickpoint
# @version 1.0 2019-07-20
#
###########################################################
set -euo pipefail
shopt -s globstar nullglob extglob

func_install_fonts() {

    declare -r WPS_FONTS_URL="https://github.com/GitHubNull/wps_fonts.git"

    @func_info "Instaling fonts..."

    git clone "${WPS_FONTS_URL}" \
        && cd wps_fonts \
        && chmod +x install.sh \
        && ./install.sh

    sudo apt-get install ttf-wqy-microhei
    sudo apt-get install ttf-wqy-zenhei
    sudo apt-get install xfonts-wqy

    @func_info "Installing fonts...Done"
}
