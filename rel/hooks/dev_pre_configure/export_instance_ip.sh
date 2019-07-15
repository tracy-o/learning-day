#!/bin/sh
set -e

export REPLACE_OS_VARS=true

if [ $LOCATION = "docker" ]
then
    echo "getting IP of docker container for erlang node name"
    export INSTANCE_IP=$(awk 'END{print $1}' /etc/hosts)
else
    echo "defaulting erlang node name IP to 127.0.0.1"
    export INSTANCE_IP="127.0.0.1"
fi