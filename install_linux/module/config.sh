#!/usr/bin/env bash
###########################################################
# @(#) config.sh
# @author quickpoint
# @version 1.0 2019-07-20
#
###########################################################
set -euo pipefail
shopt -s globstar nullglob extglob

###### PATH ######
module_config_dir="$(
    cd "$(dirname "${BASH_SOURCE[0]}")"
    pwd -P
)"

###### IMPORTS ######
#shellcheck source=/dev/null
source "${module_config_dir}/../common/common.sh"

#shellcheck source=/dev/null
source "${module_config_dir}/patch_factory.sh"

#shellcheck source=/dev/null
source "${module_config_dir}/apt_commands.sh"

#shellcheck source=/dev/null
source "${module_config_dir}/install_base.sh"

#shellcheck source=/dev/null
source "${module_config_dir}/install_fonts.sh"

#shellcheck source=/dev/null
source "${module_config_dir}/install_input_method.sh"

###### CONSTANTS ######
declare -gr SOFTWARE="/media/quickpoint/resource/linuxsf"

func_install_deb_software() {
    local file
    for file in "${SOFTWARE}"/*.deb; do
        @func_info "Installing deb software: ${file}..."

        if @func_str_regex_like "${file}" "netease*"; then
            func_install_netease_music "${file}"
            continue
        fi

        if @func_str_regex_like "${file}" "wps*"; then
            func_install_wps "${file}"
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

    func_dpkg_install "${COMMAND}" "${file}" &&
        func_install_wps_fonts
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

    func_dpkg_install "${COMMAND}" "${file}" &&
        func_fix_netease_music
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

func_install_download_tools() {
    declare -a TOOLS=(git curl)

    for each in "${TOOLS[@]}"; do

        if func_has_installed "${each}"; then
            continue
        fi

        func_apt_install "${each}"

    done
}

func_install_vim() {
    declare -r COMMAND="vim"

    func_has_installed "${COMMAND}" && return

    @func_info "Installing ${COMMAND}..."

    sudo apt install vim neovim

    curl -sLf https://spacevim.org/cn/install.sh | bash

    @func_info "intalling ${COMMAND}...Done"
}

func_install_google_chrome() {
    declare -r COMMAND="google-chrome"

    func_has_installed "${COMMAND}" && return

    @func_info "Installing ${COMMAND}..."

    sudo wget http://www.linuxidc.com/files/repo/google-chrome.list \
        -P /etc/apt/sources.list.d/

    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub |
        sudo apt-key add -

    func_apt_get_update

    declare -r SOFTWARE="google-chrome-stable"

    func_apt_install "${COMMAND}" "${SOFTWARE}"

    @func_info "Installing ${COMMAND}...Done"
}

func_install_vscode() {
    declare -r COMMAND="code"

    func_has_installed "${COMMAND}" && return

    @func_info "Installing ${COMMAND}..."

    local target="/etc/apt/sources.list.d/vscode.list"

    if @func_file_not_exists "${target}"; then
        sudo touch "${target}"
        echo "deb [arch=amd64] http://packages.microsoft.com/repos/vscode stable main" >>"${target}"
    fi

    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >microsoft.gpg

    sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg

    func_apt_source_refresh

    sudo apt-get install code

    @func_info "Installing ${COMMAND}...Done"
}

func_install_java() {
    declare -r COMMAND="java"

    func_has_installed "${COMMAND}" && return

    declare -a PACKAGES=(default-jdk default-jdk-doc)

    for each in "${PACKAGES[@]}"; do
        func_apt_install "${COMMAND}" "${each}"
    done

    func_config_java
}

func_config_java() {
    local real_path
    real_path="$(@func_file_real_execute_path "java")"

    local home_path
    home_path="$(dirname "${real_path}")"

    local line="export JAVA_HOME=${home_path}"

    func_config_if_not_exists "${HOME}/.profile" "JAVA_HOME" "${line}"
}

func_install_maven() {
    declare -r COMMAND="mvn"

    func_has_installed "${COMMAND}" && return

    @func_info "Installing ${COMMAND}..."
    sudo apt-get install -y maven
    @func_info "Installing ${COMMAND}...Done"

    func_config_maven_home
    func_config_maven_mirror
}

func_config_maven_home() {
    local real_path
    real_path="$(@func_file_real_execute_path "mvn")"

    local home_path
    home_path="$(dirname "${real_path}")"

    local line="export MAVEN_HOME=${home_path}"
    func_config_if_not_exists "${HOME}/.profile" "MAVEN_HOME" "${line}"
}

func_config_maven_mirror() {
    local settings_path="/usr/share/maven/conf/settings.xml"
    local mirror_key="http://maven.aliyun.com/nexus/content/groups/public"

    if @func_file_contains "${settings_path}" "${mirror_key}"; then
        @func_warn "${settings_path} has aleady been configed."
        return 0
    fi

    local settings_patch="settings_patch"
    local mirror="<mirror>\
                <id>nexus-aliyun</id>\
                <mirrorOf>central</mirrorOf>\
                <name>Nexus aliyun</name>\
                <url>${mirror_key}</url>\
                </mirror>"

    func_patch_on_key "${settings_patch}" "<mirrors>" "${mirror}" "${settings_path}"
}

func_config_if_not_exists() {
    local file="$1"
    local key="$2"
    local value="$3"
    shift 3

    if @func_file_not_exists "${file}"; then
        @func_warn "configure ${file} does not exists."
        return 1
    fi

    if @func_file_contains "${file}" "${key}"; then
        @func_warn "${key} has already configed in the ${file}."
        return 0
    fi

    echo "${value}" >>"${file}"
    echo "export PATH=\$PATH:\$${key}" >>"${file}"

    #shellcheck source=/dev/null
    source "${file}"
}

func_install_python() {
    declare -r COMMAND="pip3"

    func_has_installed "${COMMAND}" && return

    declare -a PACKAGES=(python3-pip)

    for each in "${PACKAGES[@]}"; do
        func_apt_install "${each}"
    done

    declare -a PIP3_PACKAGES=(pandas numpy matplotlib scipy sklearn
        jupyter black autopep8 isort pytest pylint flake8 mypy)

    for each in "${PIP3_PACKAGES[@]}"; do
        func_pip3_install "${each}"
    done

    func_install_poetry
}

func_install_poetry() {
    declare -r COMMAND="poetry"

    func_has_installed "${COMMAND}" && return

    @func_info "Installing ${COMMAND}..."
    curl -sSL https://install.python-poetry.org | python3 -
    @func_info "Installing ${COMMAND}...Done"
}

func_install_idea() {
    declare -r COMMAND="intellij-idea-community"

    func_has_installed "${COMMAND}" && return

    func_snap_install "${COMMAND}"
}
