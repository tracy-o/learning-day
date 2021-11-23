# Metrics

Belfrage publishes metrics to AWS CloudWatch and we use Grafana to visualise
them. Those metrics are used for things like investigating issues with Belfrage
or origins, monitoring the health of Belfrage, tracking its performance, etc.

## How AWS CloudWatch metric dimensions work

AWS CloudWatch supports specifying dimensions with metrics, which are basically
name/value pairs and can contain anything. Metrics with the same name, but
different set of dimensions are recorded sepately. It's possible to publish a
metric called `X` with dimension `A` and the same metric name with no
dimensions at all. If you then retrieve stats for metric `X` without specifying
dimensions you'll only get data that was recorded without any dimensions and
you won't get data that was published with dimension `A` specified.

## How metrics are sent from Belfrage to AWS CloudWatch

Metrics are sent to AWS CloudWatch from Belfrage instances by AWS CloudWatch
Agent. The agent collects some "standard" metrics about the instance (like CPU
usage, etc) and also receives custom metrics from Belfrage using StatsD
protocol. Both types of metrics are aggregated by the agent and are sent to AWS
CloudWatch once every minute (this is configurable).

AWS CloudWatch Agent adds a `host` dimension to all metrics that it collects
("standard" and custom) and also `metric_type` dimension to custom metrics.

## `BBCEnvironment` metrics dimension

When sending metrics to the agent Belfrage adds `BBCEnvironment` (which can be
`test` or `live`) dimension to them. Agent adds this dimension to all
"standard" metrics too. We don't actually need to distinguish metrics by
environment because we use different AWS accounts for test and live
environments and so we never have metrics from different environments in the
same AWS accounts. This is partly legacy setup that we've inherited, but is
also used to combine metrics from multiple hosts into a single metric (see
below).

## Metrics aggregation by AWS CloudWatch Agent

AWS CloudWatch Agent configured to aggregate metrics on certain dimensions,
including `BBCEnvironment`, which is added to all metrics. Because the value of
`BBCEnvironment` is always the same for all metrics that the agent collects, it
means that it effectively publishes all metrics twice:

* Once with all dimensions specified (including `host`)
* Once again with just `BBCEnvironment` dimension

Here's an example:

![Individual and aggregated metrics in AWS
CloudWatch](/docs/img/topics/metrics/aggregated_metric.png)

Here AWS CloudWatch agent published the custom `web.request.count` metric with
`host` and `metric_type=counter` dimensions and those are metrics from 3
different instances of Belfrage in a stack, but also published the metric with
just `BBCEnvironment` metric from each of the instances and that was recorded
as a single metric by AWS CloudWatch.

On our Grafana dashboards we generally want to see metrics from all instances
in a stack combined, so we use that aggregated metric by specifying the
`BBCEnvironment` dimension and enabling the 'match exact' option, which makes
Grafana look for the metric with `BBCEnvironment` dimension only and ignore the
individual ones from instances (because they have `host` and `metric_type`
dimensions specified as well):

![Aggregated metric in
Grafana](/docs/img/topics/metrics/aggregated_metric_grafana.png)

In short, we make AWS CloudWatch agent publish metrics per host, but also a
single one that includes data from all hosts and that's what we display on our
Grafana dashboards.

We don't have to rely on `BBCEnvironment` dimension to achieve this though:
e.g. it's possible to configure AWS CloudWatch Agent to just roll up all
metrics into one collection and disregard all dimensions completely like this:

```
"aggregation_dimensions": []
```

This would make AWS CloudWatch Agent publish individual metrics from each host
and a single one without any dimensions at all.

We do however want to publish custom metrics with dimensions (e.g. we have
poolboy pool metrics with the name of the pool as a dimension and we'd like to
use them more for other things too). Currently this means that every time we
introduce a new dimension we need to update the configuration of AWS CloudWatch
Agent too (to aggregate on the new dimension). This is a limitation of the
current approach and it would probably be better to combine metrics from hosts
into one when displaying them rather than publishing an additional aggregated
metric.