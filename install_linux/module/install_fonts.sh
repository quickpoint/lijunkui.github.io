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
    @func_info "Instaling fonts..."

    sudo apt-get install ttf-wqy-microhei
    sudo apt-get install ttf-wqy-zenhei
    sudo apt-get install xfonts-wqy

    @func_info "Installing fonts...Done"
}
