#!/bin/bash
#####################################################################
#
# Copyright (c) 2023-present, Birchi (https://github.com/Birchi)
# All rights reserved.
#
# This source code is licensed under the MIT license.
#
#####################################################################
##
# Functions
##
function usage() {
    cat << EOF
This script installs awesome shell features

Parameters:
  -h, --help                Shows the help message.

Examples:
  $(dirname $0)/install.sh
EOF
}

function parse_cmd_args() {
    args=$(getopt --options h \
                  --longoptions help -- "$@")
    
    if [[ $? -ne 0 ]]; then
        echo "Failed to parse arguments!" && usage
        exit 1;
    fi

    while test $# -ge 1 ; do
        case "$1" in
            -h | --help) usage && exit 0 ;;
            --) ;;
             *) ;;
        esac
        shift 1
    done 
}

function does_command_exist() {
    type "$1" > /dev/null 2>&1
}

function check_command() {
    if ! does_command_exist "$1" ; then
        echo "Please, install '$1' to procceed with the installation."
        exit 1
    fi
}

function check_requirements() {
    check_command "curl"
    check_command "dirname"
    check_command "getopt"
    check_command "source"
    check_command "sed"
}

function detect_profile() {
    local detected_profile
    detected_profile=""

    if [ "${SHELL#*bash}" != "$SHELL" ] ; then
        if [ -f "${HOME}/.bashrc" ] ; then
            detect_profile="${HOME}/.bashrc"
        elif [ -f "${HOME}/.bash_profile" ] ; then
            detect_profile="${HOME}/.bash_profile"
        fi
    elif [ "${SHELL#*zsh}" != "$SHELL" ] ; then
        if [ -f "${HOME}/.zshrc" ] ; then
            detect_profile="${HOME}/.zshrc"
        elif [ -f "${HOME}/.zprofile" ] ; then
            detect_profile="${HOME}/.zprofile"
        fi
    fi

    if [ -z "$detect_profile" ]; then
        for {profile_file_name} in ".profile" ".bashrc" ".bash_profile" ".zprofile" ".zshrc" ; do
            if -f ${HOME}/${profile_file_name} ; then
                detect_profile=${HOME}/${profile_file_name}
            fi
        done
    fi

    echo ${detect_profile}
}

function install_commands() {
    curl -s -L --insecure https://github.com/mtoyoda/sl/archive/refs/tags/5.02.tar.gz --output ${tmp_directory}/sl.tar.gz > /dev/null
    tar -zxf ${tmp_directory}/sl.tar.gz -C ${tmp_directory}/
    rm ${tmp_directory}/sl.tar.gz
    sl_dir=$(ls -d ${tmp_directory}/*)
    make -C ${sl_dir} > /dev/null
    cp ${sl_dir}/sl ${bin_directory}/.
    rm -rf ${sl_dir}
}

##
# Main
##
bin_directory="${HOME}/bin"
profile_file=$(detect_profile)
profile_directory="${HOME}/.profile.d"
tmp_directory="${HOME}/.birchi-tmp-install"

check_requirements

parse_cmd_args "$@"

if [ $EUID -eq 0 ] ; then
    echo "Please, run the install script as root."
    exit 1
fi

if [ ${profile_file} == "" ] ; then
    echo "Cannot detect a profile."
    exit 1
fi

sed '/# BEGIN BIRCHI SHELL/,/# END BIRCHI SHELL/d' ${profile_file} > ${profile_file}.tmp && cat ${profile_file}.tmp > ${profile_file} && rm ${profile_file}.tmp
profile_content="if [ -d \"\${HOME}/.profile.d\" ] ; then for profile_name in \$(ls \${HOME}/.profile.d/.) ; do source \${HOME}/.profile.d/\${profile_name} ; done ; fi"
printf "# BEGIN BIRCHI SHELL\n${profile_content}\n# END BIRCHI SHELL" >> ${profile_file}

mkdir -p ${profile_directory}
mkdir -p ${bin_directory}
mkdir -p ${tmp_directory}

install_commands

cat > ${profile_directory}/fun_mode.sh << EOF
function enable_birchi_mode() {
    ORIGINAL_PS1=\$PS1
    ORIGINAL_PATH=\$PATH
    export PATH=\$PATH:\${HOME}/bin
    export PS1="BIRCHI SHELL >"
    alias ls="sl"
}

function disable_birchi_mode() {
    export PS1=\$ORIGINAL_PS1
    export PATH=\$ORIGINAL_PATH
    unalias ls
}
EOF

rm -rf ${tmp_directory}
chmod 744 ${profile_file}
source ${profile_file}