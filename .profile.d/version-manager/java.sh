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
# Variables
##
JAVA_INSTALL_DIRECTORY="~/Library/Java"
JAVA_TYPE=OPENJDK
JAVA_MAX_INSTALLED_COUNT=5

##
# Exports
##
export PATH=${PATH}:${JAVA_INSTALL_DIRECTORY}/current/bin

##
# Functions
##
function java-version-manager() {
    echo "Java version manager"
}
