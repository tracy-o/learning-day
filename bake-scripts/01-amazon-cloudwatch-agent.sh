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
      ["status_code"],
      ["status_code", "route_spec"],
      ["error_code"],
      ["error_code", "route_spec"]
    ]
  },
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/component/cloudwatch.log",
            "log_group_name": "/aws/ec2/$COMPONENT_NAME",
            "log_stream_name": "$ENVIRONMENT",
            "timezone": "UTC"
          }
        ]
      }
    },
    "force_flush_interval" : 15
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
