#!/bin/bash

# Copyright (c) The MoveFuns DAO
# SPDX-License-Identifier: Apache-2.0

set -e

SCRIPT_PATH="$( cd "$( dirname "$0" )" >/dev/null 2>&1 && pwd )"
cd "$SCRIPT_PATH/.." || exit

cd starcoin

mpm package build --doc --abi --force

sed -i '/StarcoinFramework/d' build/movefuns/docs/README.md

#TODO add build script for aptos and sui