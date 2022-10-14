defmodule Belfrage.Metrics.Statsd do
  use Belfrage.MetricsMigration,
    backend: :statsd,
    metrics: [
      :statix_static_metrics,
      :statix_dynamic_metrics,
      :vm_metrics,
      :cowboy_metrics,
      :poolboy_metrics,
      :nimble_pool_metrics,
      :cachex_metrics,
      :latency_metrics,
      :request_metrics,
      :route_state_metrics,
      :cache_metrics,
      :webcore_metrics,
      :webcore_legacy_metrics,
      :platform_metrics,
      :plug_metrics,
      :plug_legacy_metrics,
      :service_error_metrics,
      :misc_metrics
    ]

  def last_value(metric_name, opts \\ []) do
    apply_metric(:last_value, metric_name, opts)
  end

  def counter(metric_name, opts \\ []) do
    apply_metric(:counter, metric_name, opts)
  end

  def summary(metric_name, opts \\ []) do
    apply_metric(:summary, metric_name, opts)
  end

  defp apply_metric(type, metric_name, opts) do
    opts = Keyword.update(opts, :tags, [:BBCEnvironment], fn tags -> [:BBCEnvironment | tags] end)
    apply(Telemetry.Metrics, type, [metric_name, opts])
  end
end
