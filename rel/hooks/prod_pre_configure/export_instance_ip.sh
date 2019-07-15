#!/bin/sh
set -e

export REPLACE_OS_VARS=true
export INSTANCE_IP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)