defmodule Belfrage.Metrics.Prometheus do
  use Belfrage.Metrics,
    backend: :prometheus,
    metrics: [
      :vm_metrics,
      :cowboy_metrics,
      :poolboy_metrics,
      :nimble_pool_metrics,
      :cachex_metrics,
      # :latency_metrics # TODO won't work till we emit new events
      # :request_metrics, # TODO won't work till we emit new events
      # :route_state_metrics,
      # :cache_metrics,
      # :service_metrics,
      # :plug_metrics,
      # :misc_metrics
    ]

  def last_value(metric_name, opts \\ []) do
    apply_metric(:last_value, metric_name, opts)
  end

  def counter(metric_name, opts \\ []) do
    apply_metric(:counter, metric_name, opts)
  end

  def summary(metric_name, opts \\ []) do
    # This is a bit of a hack to make the migration from statsd to prometheus smoother.
    # Should not confuse summary and distribution like this after the migration is finished.
    apply_metric(:distribution, metric_name, opts)
  end

  defp apply_metric(type, metric_name, opts) do
    opts =
      if type == :distribution do
        Keyword.put(opts, :reporter_options, buckets: [10, 100, 500, 1_000, 5_000, 20_000])
      else
        opts
      end

    apply(Telemetry.Metrics, type, [metric_name, opts])
  end
end
