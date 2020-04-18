#!/bin/bash

# JDKSwap - simple script to swap JDK installations.
# Copyright (c) 2020 Michael E. Cotterell
# See LICENSE

JDKSWAP_VERSION=0.2
INSTALL_DIR=~/.jdkswap.d
CONFIG=~/.jdkswap

BOLD=$(tput bold)
NORM=$(tput sgr0)

# `echo` to standard error.
# @param $@ arguments to pass into `echo`
function err_echo() {
    if [[ $1 == "_bold" ]]; then
        shift
        >&2 echo $BOLD$@$NORM
    else
        >&2 echo $@
    fi
} # err_echo

# `echo` to standard out.
# @param $@ arguments to pass into `echo`
function out_echo () {
    if [[ $1 == "_bold" ]]; then
        shift
        >&1 echo $BOLD$@$NORM
    else
        >&1 echo $@
    fi
} # out_echo

# Bails out if the current Bash version is not supported.
# @param $1 required Bash version
function require_bash_ge() {
    if [ "${BASH_VERSINFO:-0}" -lt $1 ]; then
        err_echo "This script requires Bash >= $1; found ${BASH_VERSION}."
        exit 1
    fi
} # require_bash_ge

require_bash_ge 4
[[ ! -x $CONFIG ]] && source $CONFIG || { err_echo "Missing $CONFIG"; exit 1; }
[[ ! ${#JDKSWAP_JDKS[@]} ]] && err_echo "JDKSWAP_JDKS is not set" && exit 1
[[ ! ${JDKSWAP_DEFAULT_JDK+x} ]] && err_echo "JDKSWAP_DEFAULT_JDK is not set" && exit 1

function init_jdkswap() {
    out_echo "# $INSTALL_DIR"
    out_echo "export PATH=$INSTALL_DIR/jdk/bin:\$PATH"
    out_echo "export JAVA_HOME=$INSTALL_DIR/jdk"
} # init_jdkswap

function install_jdkswap() {
    mkdir -p $INSTALL_DIR
    rm -f $INSTALL_DIR/jdk
} # install_jdkswap

function install_symlink() {
    JDK="$1"
    ln -s ${JDKSWAP_JDKS[$JDK]} $INSTALL_DIR/jdk
} # install_symlink

function install_bash_profile() {
    sed -i /${INSTALL_DIR//\//\\/}/d ~/.bash_profile
    sed -i -e :a -e '/^\n*$/{$d;N;};/\n$/ba' ~/.bash_profile
    echo "" >> ~/.bash_profile
    init_jdkswap >> ~/.bash_profile
} # install_bash_profile

function install_jdk() {
    [[ $# -eq 1 ]] && JDK="$1" || JDK="$JDKSWAP_DEFAULT_JDK"
    [[ -z ${JDKSWAP_JDKS[$JDK]} ]] && err_echo "Invalid JDK Name: $JDK" && exit 1
    [[ ! -d $INSTALL_DIR ]] && NEWSETUP=0 || NEWSETUP=1
    out_echo _bold "Installing $JDK..."
    install_jdkswap
    install_symlink $JDK
    install_bash_profile
    out_echo "Installation complete!"
    [[ $NEWSETUP -eq 0 ]] && out_echo _bold "Please logout, then log back in."
} # install_jdk

function list_jdks() {
    out_echo _bold "Available JDKs..."
    for JDK in "${!JDKSWAP_JDKS[@]}"; do
        out_echo "$JDK -> ${JDKSWAP_JDKS[$JDK]}"
    done | sort -rg -k1
} # list_jdks

function current_jdk() {
    [[ ! -d $INSTALL_DIR ]] && err_echo _bold "No JDK installed using JDKSwap!" && exit 1
    CURRENT=$(readlink -f $INSTALL_DIR/jdk)
    out_echo _bold "Current JDK installed at $INSTALL_DIR/jdk..."
    for JDK in "${!JDKSWAP_JDKS[@]}"; do
        [[ $CURRENT == ${JDKSWAP_JDKS[$JDK]} ]] && out_echo "$JDK -> ${JDKSWAP_JDKS[$JDK]}" && break
    done
} # current_jdk

function usage() {
    out_echo _bold "JDKSwap $JDKSWAP_VERSION by Dr. Cotterell"
    echo "Usage: jdkswap.sh [OPTION]"
    echo "Easily swap between available JDKs."
    echo " --help               Display this help message."
    echo " --list               List available JDKs."
    echo " --current            Display current JDK."
    echo " --install jdkname    Install jdkname."
} # usage

case $1 in
    --install) shift && install_jdk $1;;
    --list)    shift && list_jdks;;
    --current) shift && current_jdk;;
    --init)    shift && init_jdkswap;;
    *)         usage;;
esac
