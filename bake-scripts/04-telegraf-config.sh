#!/bin/bash

COMPONENT_NAME=$(cat /etc/bake-scripts/config.json | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["name"]')
ENVIRONMENT=$(cat /etc/bake-scripts/config.json | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["environment"]')

cat <<EOF | sudo tee /etc/telegraf/telegraf.conf
[global_tags]
  BBCEnvironment = "$ENVIRONMENT"
  stack_name = "$COMPONENT_NAME"

[agent]
  interval = "60s"
  round_interval = true
  metric_batch_size = 1000
  metric_buffer_limit = 10000
  collection_jitter = "0s"
  flush_interval = "60s"
  flush_jitter = "0s"
  precision = "0s"
  hostname = ""
  omit_hostname = true

[[aggregators.basicstats]]
  ## The period on which to flush & clear the aggregator.
  period = "1s"

  ## If true, the original metric will be dropped by the
  ## aggregator and will not get sent to the output plugins.
  drop_original = true

  stats = ["count","min","max","mean","non_negative_diff","non_negative_rate", "sum"]

[[outputs.cloudwatch]]
  region = "eu-west-1"
  namespace = "Belfrage"
  write_statistics = true

[[inputs.prometheus]]
  urls = ["http://127.0.0.1:9568/metrics"]
  tagexclude = ["url"]
  metric_version = 2

[[inputs.cpu]]
  percpu = true
  totalcpu = true
  collect_cpu_time = false
  report_active = false
  taginclude = ["stack_name", "BBCEnvironment"]

[[inputs.disk]]
  ignore_fs = ["tmpfs", "devtmpfs", "devfs", "iso9660", "overlay", "aufs", "squashfs"]
  taginclude = ["stack_name", "BBCEnvironment"]

[[inputs.diskio]]
  taginclude = ["stack_name", "BBCEnvironment"]

[[inputs.kernel]]
  taginclude = ["stack_name", "BBCEnvironment"]

[[inputs.mem]]
  taginclude = ["stack_name", "BBCEnvironment"]

[[inputs.processes]]
  taginclude = ["stack_name", "BBCEnvironment"]

[[inputs.swap]]
  taginclude = ["stack_name", "BBCEnvironment"]

[[inputs.system]]
  taginclude = ["stack_name", "BBCEnvironment"]

[[inputs.net]]
  taginclude = ["stack_name", "BBCEnvironment"]
EOF
