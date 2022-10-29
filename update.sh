#!/usr/bin/env bash
#
# @author quickpoint
# @version 1.0
#
# update.sh will update the linux to the lastest version and
# clean up the additional resources with one click.
###########################################################

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    ####### SCRIPT EXECUTION CONFIGURATION #######
    set -euo pipefail
    shopt -s globstar nullglob extglob
fi

@func_error_exit() {
    local JOB="$0"      # job name
    local LASTLINE="$1" # line of error occurrence
    local LASTERR="$2"  # error code
    shift 2
    
    echo -e "ERROR in ${JOB} : line ${LASTLINE} with exit code ${LASTERR}"
}
trap '@func_error_exit ${LINENO} ${?}' ERR

@func_die() {
    ret=$?
    if [ "$ret" != "0" ];then
        @func_error "in $0, with exit code ${ret}, traceback:";
        local i=0
        local size=${#FUNCNAME[@]}
        local sep=" "
        for ((i=1; i < size; i++)); do
            @func_error "${sep}" "func: ${FUNCNAME[$i]}" " line:${BASH_LINENO[$((i-1))]}"
        done
        
        exit $ret;
    fi
}
export -f @func_die

## @func_color_echo
## @param color color for the echo text
## @param prefix prefox for the echo text
## @param text text for echo
@func_color_echo() {
    if (($# != 3)); then
        echo -e "${FUNCNAME[0]}: <color>  <prefix> <text>."
        exit 1
    fi
    
    local color="$1"
    local prefix="$2"
    shift 2
    local text="$*"
    
    local COLOR_BEGIN="\033[1;"
    local COLOR_END="\033[0m"
    
    echo -e "${COLOR_BEGIN}${color}m${prefix} ${text}${COLOR_END}"
}
export -f @func_color_echo

## @func_info
@func_info() {
    local GREEN=32
    @func_color_echo "${GREEN}" "[INFO]" "$*"
}
export -f @func_info

## @func_warn
@func_warn() {
    local YELLOW=33
    @func_color_echo "${YELLOW}" "[WARN]" "$*"
}
export -f @func_warn

## @func_error
@func_error() {
    local RED=31
    @func_color_echo "${RED}" "[ERROR]" "$*"
}
export -f @func_error

func_step_run() {
    if (($# != 2)); then
        @func_error "${FUNCNAME[0]} <declare><cmd>"
        exit 1
    fi
    
    local declare="$1"
    shift
    local cmd="$*"
    
    @func_warn "---------------${declare}---------------"
    ${cmd} || @func_die
    
    @func_info "${declare} done"
}

func_step_rm_locks_if_exists() {
    func_safe_rm() {
        local target="$*"
        
        if [[ -f "${target}" ]]; then
            @func_info "removing ${target}"
            sudo rm "${target}"
        fi
    }
    
    func_rm_apt_locks_if_exists() {
        local LOCK="/var/lib/apt/lists/lock"
        func_safe_rm "${LOCK}"
    }
    
    func_rm_cache_locks_if_exists() {
        local LOCK="/var/cache/apt/archives/lock"
        func_safe_rm "${LOCK}"
    }
    
    func_rm_dpkg_locks_if_exists() {
        local LOCK_FRONTEND="/var/lib/dpkg/lock-frontend"
        func_safe_rm "${LOCK_FRONTEND}"
        
        local LOCK="/var/lib/dpkg/lock"
        func_safe_rm "${LOCK}"
    }
    
    func_rm_apt_locks_if_exists
    func_rm_cache_locks_if_exists
    func_rm_dpkg_locks_if_exists
}

func_step_apt_get_update() {
    sudo apt-get -y update
}

func_step_apt_get_upgrade() {
    sudo apt-get -y upgrade
}

func_step_apt_get_dist_upgrade() {
    sudo apt-get -y dist-upgrade
}

func_step_apt_get_clean() {
    sudo apt-get -y autoremove
    sudo apt-get -y autoclean
    sudo apt-get -y clean
}

func_step_purge() {
    declare -r SOFTWARE="deborphan"
    
    func_apt_get_install_if_not_exists() {
        func_command_in_path() {
            command -v "$@" &>/dev/null
        }
        
        func_command_not_in_path() {
            ! func_command_in_path "$@"
        }
        
        func_apt_get_install() {
            sudo apt-get -y install "$@"
        }
        
        if func_command_not_in_path "$@"; then
            func_apt_get_install "$@"
        fi
    }
    
    func_apt_get_install_if_not_exists "${SOFTWARE}"
    
    sudo "${SOFTWARE}" | xargs sudo apt-get -y remove --purge
}

func_step_uninstall_dup_image() {
    sudo dpkg --get-selections |
    grep "deinstall" |
    sed 's/deinstall/\lpurge/' |
    sudo dpkg --set-selections &&
    sudo dpkg -Pa
    
    return 0
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    func_main() {
        func_step_run "[INIT]" 'func_step_rm_locks_if_exists'
        func_step_run "[UPDATE]" 'func_step_apt_get_update'
        func_step_run "[UPDATE]" 'func_step_apt_get_upgrade'
        func_step_run "[DIST-UPGRADE]" 'func_step_apt_get_dist_upgrade'
        func_step_run "[CLEAN]" 'func_step_apt_get_clean'
        func_step_run "[PURGE]" 'func_step_purge'
        func_step_run "[IMAGE]" 'func_step_uninstall_dup_image'
    }
    
    # main script entry.
    func_main "$@"
fi
