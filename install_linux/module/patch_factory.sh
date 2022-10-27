#!/usr/bin/env bash
###########################################################
# @(#) patch_factory.sh
# @author quickpoint
# @version 1.0 2019-07-20
#
###########################################################
set -euo pipefail
shopt -s globstar nullglob extglob

###### PATH ######
module_patch_factory_dir="$(
    cd "$(dirname "${BASH_SOURCE[0]}")"
    pwd -P
)"

###### IMPORTS ######
#shellcheck source=/dev/null
source "${module_patch_factory_dir}/../common/common_str.sh"

func_patch_on_line() {

    local patch="$1"
    local line_no="$2"
    local patch_line="$3"
    local target="$4"
    shift 4

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
    shift 4

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

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    echo "patch_factory"
fi
