#!/usr/bin/env bash
#
# @(#) common_command.sh
#
# @author: quickpoint
# @version: 1.0 2022-10-11
#
# Copyright (c) 2008-2022, quickpoint.
#
# "THE FRIED-DUMPLING-WARE LICENSE", Version 1.0:
# Quickpoint wrote this file.  As long as you retain this notice you
# can do whatever you want with this stuff. If we meet some day, and you think
# this stuff is worth it, you can buy me a fried-dumpling in return.
#
################################################################################

####### SCRIPT EXECUTION CONFIGURATION #######
set -euo pipefail
shopt -s globstar nullglob extglob

@func_command_in_path() {
    command -v "$@"
}
export -f @func_command_in_path

@func_command_not_in_path() {
    ! @func_command_in_path "$@"
}
export -f @func_command_not_in_path
