# Logging

There are currently two logging solutions in place for Belfrage, each serving different purposes. We have the App logs that are surfaced in Sumologic and we also have more granular logs that are sent to CloudWatch.

## App logs

The Belfrage App logs are a critical part of understanding the behaviour and resilience of the application. These are fundamental and should always be operational. The default level is `error` and so all errors are recorded. See below for details on the Dial that can raise this value.

The configuration is set so that each instance stores its logs on the filesystem. The `td_agent` service then offloads these logs to an S3 bucket for storage. We then have a collector in [Sumologic](https://service.eu.sumologic.com/ui/) request all the logs for each Stack so that they can be easily viewed and queried.

In the first instance we should look to the logs in Sumologic when there is an issue or for keeping an eye on the status of the platform.

To check the latest logs, first go to Sumologic here https://service.eu.sumologic.com/ui/. You will need an account to access this. You can also view the logs directly in the S3 bucket if you need to but it is more cumbersome to do so.

If there are any issues using Sumologic then you may wish to check the logs directly on the instance itself. You can do this via the Instances section on Cosmos where you can request access through the Bastions. Note, whilst this will give you a realtime view of the logs there are a few things to be aware of.

* There are multiple stacks
* There are multiple instances per stack
* You are accessing a live running server so caution is required

### Logging Level Dial

The Belfrage App logs can also be adjusted via the use of a Dial. This allows us to elevate the level from `error`. This should be done sparingly as the debug logs from Monitor can be used. If the dial is changed make sure to change it back as soon as you can.

The Dial can be used if there are issues with Monitor or you need to clarify events in order to gain more information. In the first instance use the debug logs in Cloudwatch.

Increasing the log level in Belfrage using the dial will means much more noise in the logs and make it harder to spot actual errors. It would mean an increase in costs so we need to be mindful of how long they are increased for.

## Cloudwatch logs

Belfrage also stores logs that are then sent to Cloudwatch. These are logged at a higher level, currently set to the level of `warn`, so provide extra information when debugging an issue. They are always available for the specified retention period and not currently intended as a replacement to the app logs.

The logs are stored in `/var/log/component/cloudwatch.log` and offloaded to the Cloudwatch group named after the stack `/aws/ec2/[stack-name]`. The best way to query the logs in CloudWatch is to use [Log Insights](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/CWL_QuerySyntax.html).