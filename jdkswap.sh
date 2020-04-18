#!/bin/bash

JDKSWAP_VERSION=0.2
INSTALL_DIR=~/.jdkswap

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

# TODO switch install dir to .jdkswap.d and use .jdkswap as config file
declare -A JDKS=(
    ["oracle:jdk-8.0.251"]="/path/to/oracle/jdk1.8.0_251"
    ["oracle:jdk-14.0.1"]="/path/to/oracle/jdk-14.0.1"
    ["openjdk:jdk-11.0.2"]="/path/to/openjdk/jdk-11.0.2"
)

DEFAULT_JDK="oracle:jdk-8.0.192"

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
    ln -s ${JDKS[$JDK]} $INSTALL_DIR/jdk
} # install_symlink

function install_bash_profile() {
    sed -i /${INSTALL_DIR//\//\\/}/d ~/.bash_profile
    sed -i -e :a -e '/^\n*$/{$d;N;};/\n$/ba' ~/.bash_profile
    echo "" >> ~/.bash_profile
    init_jdkswap >> ~/.bash_profile
} # install_bash_profile

function install_jdk() {
    [[ $# -eq 1 ]] && JDK="$1" || JDK="$DEFAULT_JDK"
    [[ -z ${JDKS[$JDK]} ]] && err_echo "Invalid JDK Name: $JDK" && exit 1
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
    for JDK in "${!JDKS[@]}"; do
        out_echo "$JDK -> ${JDKS[$JDK]}"
    done | sort -rg -k1
} # list_jdks

function current_jdk() {
    [[ ! -d $INSTALL_DIR ]] && err_echo _bold "No JDK installed using JDKSwap!" && exit 1
    CURRENT=$(readlink -f $INSTALL_DIR/jdk)
    out_echo _bold "Current JDK installed at $INSTALL_DIR/jdk..."
    for JDK in "${!JDKS[@]}"; do
        [[ $CURRENT == ${JDKS[$JDK]} ]] && out_echo "$JDK -> ${JDKS[$JDK]}" && break
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
