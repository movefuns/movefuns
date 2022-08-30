#!/bin/bash

# Copyright (c) The MoveFuns DAO
# SPDX-License-Identifier: Apache-2.0

#TODO add build script for aptos and sui

set -e

SCRIPT_PATH="$( cd "$( dirname "$0" )" >/dev/null 2>&1 && pwd )"
cd "$SCRIPT_PATH/starcoin/.." || exit

mpm package build --doc --abi --force

rm -r build/StarcoinFramework
sed -i '/StarcoinFramework/d' build/starcoin-framework-commons/docs/README.md