#!/bin/bash

set -x

export MULEADORE64_DIR=~/muleadore64

source ~/.bashrc
nvm use 6
mkdir -p /tmp/img
cd $MULEADORE64_DIR/c64-app
/Applications/Vice64/tools/x64 $MULEADORE64_DIR/c64-app/build/c64-pv.prg
