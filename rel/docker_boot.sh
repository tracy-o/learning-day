#!/bin/sh
set -e

export REPLACE_OS_VARS=true

# set INSTANCE_IP to be IP of docker container
export INSTANCE_IP=$(awk 'END{print $1}' /etc/hosts)

_build/dev/rel/belfrage/bin/belfrage "$@"