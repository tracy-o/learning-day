defmodule Belfrage.Metrics.Misc do
  import Telemetry.Metrics

  def metrics() do
    cache_metrics =
      for cache_metric <- [:local, :distributed] do
        ["cache.#{cache_metric}.miss"] ++
          for freshness <- [:fresh, :stale] do
            ["cache.#{cache_metric}.#{freshness}.hit"]
          end
      end
      |> :lists.flatten()

    metrics =
      [
        "error.view.render.unhandled_content_type",
        "error.pipeline.process",
        "error.pipeline.process.unhandled",
        "error.route_state.state",
        "error.service.Fabl.timeout",
        "error.service.Fabl.request",
        "clients.lambda.assume_role_failure",
        "invalid_content_encoding_from_origin",
        "web.response.uncompressed",
        "ccp.unexpected_response",
        "ccp.fetch_error",
        "ccp.put_error"
      ] ++ cache_metrics

    for metric <- metrics do
      event_name = [:belfrage | String.split(metric, ".") |> Enum.map(&String.to_atom/1)]
      counter(metric, event_name: event_name, tags: [:BBCEnvironment, :route_spec])
    end
  end
end
