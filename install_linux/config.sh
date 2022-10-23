#!/usr/bin/env bash
###########################################################
# @(#) config.sh
# @author quickpoint
# @version 1.0 2019-07-20
#
###########################################################
set -euo pipefail
shopt -s globstar nullglob extglob

###### IMPORTS ######
source "common.sh"

###### CONSTANTS ######
APT_SOURCES_LIST="/etc/apt/sources.list"
ALIYUN_MIRROR_KEY="mirrors.aliyun.com"
SOFTWARE="/media/quickpoint/resource/linuxsf"

func_apt_sources_backup() {
    @func_warn "Backup ${APT_SOURCES_LIST}..."

    local target="${APT_SOURCES_LIST}.orig"

    sudo cp "${APT_SOURCES_LIST}" "${target}"

    @func_warn "Backup ${APT_SOURCES_LIST}...Done."
}

func_apt_switch() {

    if @func_file_not_exists "${APT_SOURCES_LIST}"; then
        @func_warn "${APT_SOURCES_LIST} does not exist, touch one."
        sudo touch "${APT_SOURCES_LIST}"
    fi

    if @func_file_contains "${APT_SOURCES_LIST}" "${ALIYUN_MIRROR_KEY}"; then
        @func_warn "Already switched to aliyun mirror."
        return 0
    fi

    func_apt_sources_backup

    @func_warn "Switch to aliyun mirror..."

    local ALIYUN_MIRROR="aliyun.sources.list"
    if @func_file_not_exists "${ALIYUN_MIRROR}"; then
        func_apt_format_template "${ALIYUN_MIRROR}"
    fi

    sudo cp "${ALIYUN_MIRROR}" "${APT_SOURCES_LIST}"

    @func_warn "Switch to aliyun mirror...Done."

    func_apt_source_refresh
    return 0
}

func_apt_format_template() {
    cat >"$1" <<EOF
deb http://mirrors.aliyun.com/ubuntu/ jammy main restricted universe multiverse
#deb-src http://mirrors.aliyun.com/ubuntu/ jammy main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ jammy-security main restricted universe multiverse
#deb-src http://mirrors.aliyun.com/ubuntu/ jammy-security main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ jammy-updates main restricted universe multiverse
#deb-src http://mirrors.aliyun.com/ubuntu/ jammy-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ jammy-proposed main restricted universe multiverse
#deb-src http://mirrors.aliyun.com/ubuntu/ jammy-proposed main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ jammy-backports main restricted universe multiverse
#deb-src http://mirrors.aliyun.com/ubuntu/ jammy-backports main restricted universe multiverse    
EOF
}

func_apt_source_refresh() {
    sudo apt-get update
}

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

func_patch_on_line() {

    local patch="$1"
    local line_no="$2"
    local patch_line="$3"
    local target="$4"

    local i=0
    local line=""
    IFS=$'\n'
    while read -r line; do
        i=$((i + 1))
        if ((i == line_no)); then
            echo "${patch_line}" >>"${patch}"
        fi
        echo "${line}" >>"${patch}"
    done <"${target}"

    sudo mv "${patch}" "${target}"
}

func_patch_on_key() {
    local patch="$1"
    local key="$2"
    local patch_line="$3"
    local target="$4"

    local line=""
    IFS=$'\n'
    while read -r line; do
        echo "${line}" >>"${patch}"
        if @func_str_regex_like "${line}" "${key}"; then
            echo "${patch_line}" >>"${patch}"
        fi
    done <"${target}"

    sudo mv "${patch}" "${target}"
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

    func_apt_source_refresh

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

func_step_run() {
    if (($# != 2)); then
        @func_error "${FUNCNAME[0]} <declare><cmd>"
        exit 1
    fi

    local declare="$1"
    shift
    local cmd="$*"

    @func_warn "---------------${declare}---------------"
    ${cmd}
}

func_main() {
    func_step_run "[APT SWITCH]" 'func_apt_switch'
    func_step_run "[INSTALL TOOLS]" 'func_install_tools'
    func_step_run "[INSTALL VIM]" 'func_install_vim'
    func_step_run "[INSTALL CHROME]" 'func_install_google_chrome'
    func_step_run "[INSTALL VSCODE]" 'func_install_vscode'
    func_step_run "[INSTALL IM]" 'func_install_input_method'
    func_step_run "[INSTALL DEB]" 'func_install_deb_software'
    #func_step_run "[INSTALL FONTS]" 'func_install_fonts'

    func_step_run "[INSTALL JAVA]" 'func_install_java'
    func_step_run "[INSTALL MAVEN]" 'func_install_maven'
    func_step_run "[INSTALL PYTHON]" 'func_install_python'
    func_step_run "[INSTALL IDEA]" 'func_install_idea'

}

func_main "$@"
