#!/bin/bash

COMPONENT_NAME=$(cat /etc/bake-scripts/config.json | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["name"]')
ENVIRONMENT=$(cat /etc/bake-scripts/config.json | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["environment"]')

cat > /etc/cloudwatch-agent-config.json <<EOF
{
  "agent": {
    "logfile": "/opt/aws/amazon-cloudwatch-agent/logs/amazon-cloudwatch-agent.log"
  },
  "metrics": {
    "namespace": "BBCApp/$COMPONENT_NAME",
    "metrics_collected": {
      "statsd": {
        "service_address": ":8125",
        "metric_separator": ".",
        "metrics_collection_interval": 1,
        "metrics_aggregation_interval": 60
      },
      "cpu": {
        "measurement": [
          "cpu_usage_idle",
          "cpu_usage_iowait"
        ],
        "append_dimensions": {
          "BBCEnvironment": "$ENVIRONMENT"
        }
      },
      "disk": {
        "resources": [
          "/"
        ],
        "measurement": [
          "disk_used_percent"
        ],
        "append_dimensions": {
          "BBCEnvironment": "$ENVIRONMENT"
        }
      },
      "mem": {
        "measurement": [
          "mem_used_percent"
        ],
        "append_dimensions": {
          "BBCEnvironment": "$ENVIRONMENT"
        }
      },
      "processes": {
        "measurement": [
          "running",
          "sleeping",
          "dead"
        ],
        "append_dimensions": {
          "BBCEnvironment": "$ENVIRONMENT"
        }
      },
      "net": {
        "measurement": [
          "bytes_recv",
          "bytes_sent",
          "drop_in",
          "drop_out",
          "err_in",
          "err_out",
          "packets_recv",
          "packets_sent"
        ],
        "append_dimensions": {
          "BBCEnvironment": "$ENVIRONMENT"
        }
      },
      "netstat": {
        "measurement": [
          "tcp_established",
          "tcp_syn_sent",
          "tcp_close"
        ],
        "append_dimensions": {
          "BBCEnvironment": "$ENVIRONMENT"
        },
        "metrics_collection_interval": 60
      }
    },
    "aggregation_dimensions" : [
      ["BBCEnvironment"],
      ["BBCEnvironment", "pool_name"],
      ["BBCEnvironment", "cache_name"],
      ["supervisor_id"],
      ["platform"],
      ["status_code"],
      ["status_code", "platform"],
      ["status_code", "platform", "route_spec"],
      ["status_code", "route_spec"],
      ["status_code", "preflight_service"],
      ["preflight_service", "error_type"],
      ["preflight_service", "type"],
      ["preflight_service"],
      ["error_code"],
      ["error_code", "route_spec"],
      ["route_spec"]
    ]
  }
}
EOF

cat > /etc/systemd/system/start-cloudwatch-agent.service <<EOF
[Unit]
Description=Start the amazon cloudwatch agent service
After=network.target network-online.target
[Service]
ExecStart=/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/etc/cloudwatch-agent-config.json -s
[Install]
WantedBy=multi-user.target
EOF

systemctl enable start-cloudwatch-agent
