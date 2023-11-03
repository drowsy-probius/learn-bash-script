#!/bin/bash

SCRIPT_DIR="."

######
# Your Answer Here
SCRIPT_DIR=$(realpath $(dirname "$0")) # For WSL, Linux
# SCRIPT_DIR=$(dirname $(readlink -f "$0")) # For Mac, WSL, Linux
######

cd "$SCRIPT_DIR"
echo `pwd`
