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
NODEJS_INSTALL_DIRECTORY="~/Library/NodeJS"
NODEJS_MAX_INSTALLED_COUNT=5

##
# Exports
##
export PATH=${PATH}:${NODEJS_INSTALL_DIRECTORY}/current/bin

##
# Functions
##
function nodejs-version-manager() {
    echo "NodeJS version manager"
}
