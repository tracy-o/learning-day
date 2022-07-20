#!/bin/bash

COMPONENT_NAME=$(cat /etc/bake-scripts/config.json | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["name"]')
ENVIRONMENT=$(cat /etc/bake-scripts/config.json | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["environment"]')

cat <<EOF | sudo tee /etc/telegraf/telegraf.conf
[global_tags]
  BBCEnvironment = "$ENVIRONMENT"
  stack_name = "$COMPONENT_NAME"

[agent]
  interval = "10s"
  round_interval = true
  metric_batch_size = 1000
  metric_buffer_limit = 10000
  collection_jitter = "0s"
  flush_interval = "10s"
  flush_jitter = "0s"
  precision = "0s"
  hostname = ""
  omit_hostname = false

[[outputs.cloudwatch]]
  region = "eu-west-1"
  namespace = "Belfrage"

[[inputs.prometheus]]
  urls = ["http://127.0.0.1:9568/metrics"]

[[inputs.cpu]]
  percpu = true
  totalcpu = true
  collect_cpu_time = false
  report_active = false

[[inputs.disk]]
  ignore_fs = ["tmpfs", "devtmpfs", "devfs", "iso9660", "overlay", "aufs", "squashfs"]

[[inputs.diskio]]

[[inputs.kernel]]

[[inputs.mem]]

[[inputs.processes]]

[[inputs.swap]]

[[inputs.system]]
EOF
