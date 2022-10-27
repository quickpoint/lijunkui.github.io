#!/usr/bin/env bash
###########################################################
# @(#) run.sh
# @author quickpoint
# @version 1.0 2019-07-20
#
###########################################################
set -euo pipefail
shopt -s globstar nullglob extglob

###### PATH ######
bin_run_dir="$(
    cd "$(dirname "${BASH_SOURCE[0]}")"
    pwd -P
)"

###### IMPORTS ######
#shellcheck source=/dev/null
source "${bin_run_dir}/../module/imports.sh"

func_main() {
    func_step_run "[APT SWITCH]" 'func_apt_sources_switch'
    func_step_run "[INSTALL TOOLS]" 'func_install_download_tools'
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
    func_step_run "[INSTALL PYCHARM]" 'func_install_pycharm'
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    func_main "$@"
fi
