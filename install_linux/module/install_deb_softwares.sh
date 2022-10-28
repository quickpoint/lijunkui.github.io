#!/usr/bin/env bash
###########################################################
# @(#) install_deb_softwares.sh
# @author quickpoint
# @version 1.0 2019-07-20
#
###########################################################

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    
    ####### SCRIPT EXECUTION CONFIGURATION #######
    set -euo pipefail
    shopt -s globstar nullglob extglob
    
    ###### PATH ######
    module_install_deb_dir="$(
        cd "$(dirname "${BASH_SOURCE[0]}")"
        pwd -P
    )"
    
    ###### IMPORTS ######
    #shellcheck source=/dev/null
    source "${module_install_deb_dir}/../common/imports.sh"
    
    #shellcheck source=/dev/null
    source "${module_install_deb_dir}/patch_factory.sh"
    
    #shellcheck source=/dev/null
    source "${module_install_deb_dir}/apt_commands.sh"
    
    #shellcheck source=/dev/null
    source "${module_install_deb_dir}/install_base.sh"
fi

###### CONSTANTS ######
declare -gr SOFTWARE="/media/quickpoint/resource/linuxsf"

func_install_deb_software() {
    local file
    for file in "${SOFTWARE}"/*.deb; do
        @func_info "Installing deb software: ${file}..."
        
        if @func_str_regex_like "${file}" "netease*"; then
            func_install_netease_music "${file}"
            func_fix_netease_music
            continue
        fi
        
        if @func_str_regex_like "${file}" "wps*"; then
            func_install_wps "${file}"
            func_install_wps_fonts
            continue
        fi
        
        func_dpkg_install "${file}"
    done
}

func_install_wps() {
    local file="$1"
    shift
    
    declare -r COMMAND="wps"
    
    func_has_installed "${COMMAND}" && return
    
    func_dpkg_install "${COMMAND}" "${file}"
}

func_install_wps_fonts() {
    declare -r WPS_FONTS_URL="https://github.com/GitHubNull/wps_fonts.git"
    
    @func_info "Instaling fonts..."
    
    declare -r WPS_FONTS="wps_fonts"
    
    if @func_dir_not_exists "${WPS_FONTS}"; then
        git clone "${WPS_FONTS_URL}"
    fi
    
    cd "${WPS_FONTS}" &&
    chmod +x install.sh &&
    ./install.sh
}

func_install_netease_music() {
    local file="$1"
    shift
    
    declare -r COMMAND="netease-cloud-music"
    
    func_has_installed "${COMMAND}" && return
    
    func_dpkg_install "${COMMAND}" "${file}"
}

func_fix_netease_music() {
    declare -r MUSIC="netease-cloud-music"
    
    @func_info "Fixing ${MUSIC}..."
    
    local NETEASE="/opt/netease/netease-cloud-music/netease-cloud-music.bash"
    
    declare -r patch="netease.music.patch.bash"
    local patch_line="cd /lib/x86_64-linux-gnu/"
    local line_no=2
    
    func_patch_on_line "${patch}" "${line_no}" "${patch_line}" "${NETEASE}"
    
    sudo chmod +x "${NETEASE}"
    
    sudo apt-get install libcanberra-gtk-module
    
    @func_info "Fixing ${MUSIC}...Done"
}
