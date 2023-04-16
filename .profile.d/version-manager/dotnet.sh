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
DOTNET_INSTALL_DIRECTORY="~/Library/dotnet"
DOTNET_MAX_INSTALLED_COUNT=5

##
# Exports
##
export PATH=${PATH}:${DOTNET_INSTALL_DIRECTORY}/current

##
# Functions
##
function dotnet-version-manager() {
    echo ".NET version manager"
}
