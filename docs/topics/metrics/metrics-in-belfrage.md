# Metrics

Belfrage publishes metrics to AWS CloudWatch and we use Grafana to visualise
them. Those metrics are used for things like investigating issues with Belfrage
or origins, monitoring the health of Belfrage, tracking its performance, etc.

## Unifying our approach to use `:telemetry`

Currently in Belfrage we have a mixture of approaches to tracking:

* We use `Belfrage.Event` module for tracking some things which sends data to
  Belfrage Monitor app, but also uses the library called `Statix` to send it to
  AWS CloudWatch. `Statix` sends data using `StatsD` protocol to AWS CloudWatch
  Agent which in turn sends it to AWS CloudWatch.
* We use `Statix` directly in some other places.
* We use `:telemetry` to track certain things (mostly things like Erlang VM
  stats or 3rd party libraries like Cowboy): we listen to `:telemetry` events
  and convert them to metrics that are then sent to AWS CloudWatch Agent (and
  to AWS CloudWatch).
* We have some custom processes that periodically take measurements and use one
  of the approaches above to report them to AWS CloudWatch.

Given that `:telemetry` can do everything we need, it's become a de facto
standard for metrics in Elixir (many 3rd party libraries have adopted it) and
it's straightforward to test (it's possible to listen to Telemetry events in
tests and verify them), we've decided to gradually migrate all tracking to
`:telemetry`.

If you're adding new metrics, please use `:telemetry` and if you're updating an
existing one (or code that tracks something using one of the other approaches
above) please consider updating it to use `:telemetry`.

## Tracking with `:telemetry`

Here's how tracking using `:telemetry` currently works:

* We've got a module called `Belfrage.Metrics` that can be used to track events
  or take measurements. It emits `:telemetry` events under the hood and it
  exists to provide a standard way of doing that. If you need to do something
  that this module doesn't support, please update it instead of using
  `:telemetry` directly.
* We use
  [`Telemetry.Metrics`](https://hexdocs.pm/telemetry_metrics/0.6.1/Telemetry.Metrics.html)
  to convert `:telemetry` events to metrics. and
  [`TelemetryMetricsStatsD`](https://hexdocs.pm/telemetry_metrics_statsd/TelemetryMetricsStatsd.html)
  to send them using `StatsD` protocol to AWS CloudWatch Agent.
* If we need to take periodic measurements, we use
  [`:telemetry_poller](https://hexdocs.pm/telemetry_poller/readme.html) which
  is able to periodically collect some standard system- or process-level
  measurements as well as custom ones. 

In short, here's what you need to do track something:

* Use `Belfrage.Metrics` in the code where tracking needs to happen.
* Update the `TelemetryMetricsStatsD` configuration in
  `Belfrage.Metrics.TelemetrySupervisor` to convert the events to metrics.
* If you need to periodically track something, use `:telemetry_poller`. Please
  note that `:telemetry_poller` stops taking custom measurements on first
  failure, so if taking a custom measurement may raise an exception or result
  in an exist you'll need to handle that (e.g. wrap it in a `try/catch`).
* If you're using a dimension with your metric, update the AWS CloudWatch Agent
  configuration (in `bake-scripts`) to aggregate on this dimension if necessary
  (see below for more info on this).
* At this point the new metric should become available in AWS CloudWatch and
  you should be able to update the Grafana dashboards to use it.

## Things we still need to figure out

* What's the best way to configure `TelemetryMetricsStatsD` to convert
  `:telemetry` events to metrics. Currently it's all in a single module
  (`Belfrage.Metrics.TelemetrySupervisor`), but this won't scale. We'll
  probably need to break up this configuration somehow.
* How do we configure `:telemetry_poller`: should we have a single process that
  takes all periodic measurements (probably won't scale) or should we have
  multiple ones configured in different places.

## How AWS CloudWatch metric dimensions work

AWS CloudWatch supports specifying dimensions with metrics, which are basically
name/value pairs and can contain anything. Metrics with the same name, but
different set of dimensions are recorded separately. It's possible to publish a
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
