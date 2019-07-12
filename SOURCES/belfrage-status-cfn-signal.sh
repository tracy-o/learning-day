#!/bin/bash -x

COMPONENT_NAME=$(cat /etc/bake-scripts/config.json | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["name"]')
ENVIRONMENT=$(cat /etc/bake-scripts/config.json | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["environment"]')

# STACKID should be changed to evaluate to the name of your Main stack
STACKID=${ENVIRONMENT}-${COMPONENT_NAME}-main

# beginning of app testing loop
# edit the contents of the next two lines to define a specific test for your application
# until [ "$status" == "pong" ]; do
# status=$(sudo -u component /home/component/belfrage/bin/belfrage ping);
# sleep 5;
# done
# end of app testing loop
sleep 5;
# We should only reach here if the check above has confirmed that the app is up
# resource_id should be set to the Logical Resource id of the instances AutoScalingGroup
/usr/local/cfn-signal/bin/signal --resource_id "ComponentAutoScalingGroup" --stack_name "${STACKID}" --status "SUCCESS"
