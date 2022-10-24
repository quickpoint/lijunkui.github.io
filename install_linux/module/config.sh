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
curr_dir="$(
    cd "$(dirname "${BASH_SOURCE[0]}")"
    pwd -P
)"

###### IMPORTS ######
#shellcheck source=/dev/null
source "${curr_dir}/common.sh"
#shellcheck source=/dev/null
source "${curr_dir}/apt_commands.sh"
#shellcheck source=/dev/null
source "${curr_dir}/patch_factory.sh"

###### CONSTANTS ######
SOFTWARE="/media/quickpoint/resource/linuxsf"

func_install_input_method() {

    local COMMAND="fcitx"

    func_pre_install_check "${COMMAND}" && return

    @func_info "Installing ${COMMAND}..."

    sudo apt-get install fcitx fcitx-googlepinyin im-config

    @func_info "Installing ${COMMAND}...Done"
}

func_install_deb_software() {

    local file
    for file in "${SOFTWARE}"/*.deb; do
        @func_info "Installing deb software: ${file}..."

        if @func_str_regex_like "${file}" "netease*"; then
            func_install_netease_music "${file}"
        fi
    done
}

func_install_netease_music() {

    local COMMAND="netease-cloud-music"

    func_pre_install_check "${COMMAND}" && return

    sudo dpkg -i "$*" && func_fix_netease_music
}

func_fix_netease_music() {

    local MUSIC="netease-cloud-music"

    @func_info "Fixing ${MUSIC}..."

    local NETEASE="/opt/netease/netease-cloud-music/netease-cloud-music.bash"

    local patch="netease.music.patch.bash"
    local patch_line="cd /lib/x86_64-linux-gnu/"
    local line_no=2

    func_patch_on_line "${patch}" "${line_no}" "${patch_line}" "${NETEASE}"

    sudo chmod +x "${NETEASE}"

    sudo apt-get install libcanberra-gtk-module

    @func_info "Fixing ${MUSIC}...Done"
}

func_install_tools() {
    declare -a tools=(git curl)

    for each in "${tools[@]}"; do

        if @func_command_in_path "${each}"; then
            @func_warn "${each} has already been installed."
        else
            @func_info "Installing ${each}..."
            sudo apt-get install "${each}"
            @func_info "Installing ${each}...Done"
        fi
    done
}

func_install_fonts() {

    @func_info "Instaling fonts..."

    git clone https://github.com/GitHubNull/wps_fonts.git &&
        cd wps_fonts &&
        chmod +x install.sh &&
        ./install.sh

    sudo apt-get install ttf-wqy-microhei
    sudo apt-get install ttf-wqy-zenhei
    sudo apt-get install xfonts-wqy

    @func_info "Installing fonts...Done"
}

func_install_vim() {

    local COMMAND="vim"

    func_pre_install_check "${COMMAND}" && return

    @func_info "Installing ${COMMAND}..."

    sudo apt install vim neovim
    curl -sLf https://spacevim.org/cn/install.sh | bash

    @func_info "intalling ${COMMAND}...Done"
}

func_install_google_chrome() {

    local COMMAND="google-chrome"

    func_pre_install_check "${COMMAND}" && return

    @func_info "Installing ${COMMAND}..."

    sudo wget http://www.linuxidc.com/files/repo/google-chrome.list \
        -P /etc/apt/sources.list.d/

    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub |
        sudo apt-key add -

    func_apt_get_update

    sudo apt install google-chrome-stable

    @func_info "Installing ${COMMAND}...Done"
}

func_install_vscode() {
    local COMMAND="code"

    func_pre_install_check "${COMMAND}" && return

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

    local COMMAND="java"

    func_pre_install_check "${COMMAND}" && return

    declare -a PACKAGES=(default-jdk default-jdk-doc)

    for each in "${PACKAGES[@]}"; do
        @func_info "Installing ${each}..."
        sudo apt-get install -y "${each}"
        @func_info "Installing ${each}...Done"
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
    local COMMAND="mvn"

    func_pre_install_check "${COMMAND}" && return

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

    local COMMAND="pip3"

    func_pre_install_check "${COMMAND}" && return

    declare -a PACKAGES=(python3-pip)

    for each in "${PACKAGES[@]}"; do
        @func_info "Installing ${each}..."
        sudo apt-get install -y "${each}"
        @func_info "Installing ${each}...Done"
    done

    @func_info "Installing poetry..."
    curl -sSL https://install.python-poetry.org | python3 -
    @func_info "Installing poetry...Done"

    declare -a PIP3_PACKAGES=(pandas numpy matplotlib scipy sklearn
        jupyter black autopep8 isort pytest pylint flake8 mypy)

    for each in "${PIP3_PACKAGES[@]}"; do
        @func_info "Installing ${each}..."
        pip3 install "${each}"
        @func_info "Installing ${each}...Done"
    done
}

func_install_idea() {

    local COMMAND="intellij-idea-community"

    func_pre_install_check "${COMMAND}" && return

    sudo snap install "${COMMAND}"
}

func_pre_install_check() {

    local COMMAND="$1"

    if @func_command_in_path "${COMMAND}"; then
        @func_warn "${COMMAND} has already been installed."
        return 0
    fi

    return 1
}


