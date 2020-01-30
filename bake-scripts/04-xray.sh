#!/bin/bash

ARN=$(cat /etc/bake-scripts/config.json | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["configuration"]["XRAY_ROLE_ARN"]')

cat > /etc/amazon/xray/cfg.yaml <<EOF
# Maximum buffer size in MB (minimum 3). Choose 0 to use 1% of host memory.
TotalBufferSizeMB: 0
# Maximum number of concurrent calls to AWS X-Ray to upload segment documents.
Concurrency: 8
# Send segments to AWS X-Ray service in a specific region
Region: ""
# Change the X-Ray service endpoint to which the daemon sends segment documents.
Endpoint: ""
Socket:
  # Change the address and port on which the daemon listens for UDP packets containing segment documents.
  UDPAddress: "127.0.0.1:2000"
  # Change the address and port on which the daemon listens for HTTP requests to proxy to AWS X-Ray.
  TCPAddress: "127.0.0.1:2000"
Logging:
  LogRotation: true
  # Change the log level, from most verbose to least: dev, debug, info, warn, error, prod (default).
  LogLevel: "prod"
  # Output logs to the specified file path.
  LogPath: ""
# Turn on local mode to skip EC2 instance metadata check.
LocalMode: false
# Amazon Resource Name (ARN) of the AWS resource running the daemon.
ResourceARN: ""
# Assume an IAM role to upload segments to a different account.
RoleARN: "${ARN}"
# Disable TLS certificate verification.
NoVerifySSL: false
# Upload segments to AWS X-Ray through a proxy.
ProxyAddress: ""
# Daemon configuration file format version.
Version: 2
EOF

systemctl enable xray