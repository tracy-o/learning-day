defmodule Belfrage.Metrics.TelemetrySupervisor do
  use Supervisor
  import Telemetry.Metrics

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_args) do
    children = [
      {
        TelemetryMetricsStatsd,
        metrics: telemetry_metrics(),
        global_tags: [BBCEnvironment: Application.get_env(:belfrage, :production_environment)],
        formatter: :datadog
      }
    ]

    Supervisor.init(children, strategy: :one_for_one, max_restarts: 40)
  end

  defp telemetry_metrics do
    vm_metrics() ++
      cowboy_metrics() ++
      poolboy_metrics() ++
      Belfrage.Metrics.Cachex.metrics() ++
      latency_metrics() ++
      request_metrics() ++
      route_state_metrics() ++
      cache_metrics() ++
      service_metrics() ++
      plug_metrics()
  end

  defp vm_metrics() do
    [
      last_value("vm.memory.total", unit: {:byte, :kilobyte}, tags: [:BBCEnvironment]),
      last_value("vm.system_counts.process_count", tags: [:BBCEnvironment]),
      last_value("vm.system_counts.atom_count", tags: [:BBCEnvironment]),
      last_value("vm.system_counts.port_count", tags: [:BBCEnvironment]),
      last_value("vm.total_run_queue_lengths.total", tags: [:BBCEnvironment]),
      last_value("vm.total_run_queue_lengths.cpu", tags: [:BBCEnvironment]),
      last_value("vm.total_run_queue_lengths.io", tags: [:BBCEnvironment])
    ]
  end

  defp cowboy_metrics() do
    [
      summary("cowboy.request.stop.duration", unit: {:native, :millisecond}, tags: [:BBCEnvironment]),
      counter("cowboy.request.exception.count", tags: [:BBCEnvironment]),
      counter("cowboy.request.early_error.count", tags: [:BBCEnvironment]),
      counter("cowboy.request.idle_timeout.count",
        event_name: "cowboy.request.stop",
        keep: &match?(%{error: {:connection_error, :timeout, _}}, &1),
        tags: [:BBCEnvironment]
      )
    ]
  end

  defp poolboy_metrics() do
    [
      last_value("poolboy.available_workers.count",
        measurement: :available_workers,
        event_name: "belfrage.poolboy.status",
        tags: [:pool_name, :BBCEnvironment]
      ),
      last_value("poolboy.overflow_workers.count",
        measurement: :overflow_workers,
        event_name: "belfrage.poolboy.status",
        tags: [:pool_name, :BBCEnvironment]
      ),
      last_value("poolboy.pools.max_saturation",
        event_name: "belfrage.poolboy.pools",
        tags: [:BBCEnvironment]
      )
    ]
  end

  defp latency_metrics() do
    Enum.map(
      ~w(
      plug_pipeline
      process_request_headers
      set_request_route_state_data
      filter_request_data
      check_if_personalised_request
      generate_request_hash
      fetch_early_response_from_cache
      request_pipeline
      parse_session_token
      pre_cache_compression
      fetch_fallback
      cache_response
      decompress_response
      generate_internal_response
      set_response_headers
      return_json_response
      return_binary_response
    ),
      &latency_metric/1
    )
  end

  defp latency_metric(name) do
    summary("belfrage.latency.#{name}",
      event_name: "belfrage.#{name}.stop",
      measurement: :duration,
      unit: {:native, :microsecond},
      tags: [:BBCEnvironment]
    )
  end

  defp request_metrics() do
    Enum.map(~w(idcta_config jwk assume_webcore_lambda_role), fn name ->
      summary("belfrage.request.#{name}.duration",
        event_name: "belfrage.request.#{name}.stop",
        unit: {:native, :millisecond},
        tags: [:BBCEnvironment]
      )
    end)
  end

  defp route_state_metrics() do
    [
      last_value("circuit_breaker.throughput",
        measurement: :throughput,
        event_name: "belfrage.circuit_breaker.throughput",
        tags: [:BBCEnvironment, :route_spec]
      ),
      counter("circuit_breaker.applied",
        event_name: "belfrage.circuit_breaker.applied",
        tags: [:BBCEnvironment, :route_spec]
      ),
      counter("circuit_breaker.open",
        event_name: "belfrage.circuit_breaker.open",
        tags: [:BBCEnvironment, :route_spec]
      )
    ]
  end

  defp cache_metrics() do
    [counter("cache.local.fetch_exit", tags: [:BBCEnvironment])]
  end

  defp service_metrics() do
    webcore = [
      counter(
        "webcore.request.count",
        event_name: "belfrage.webcore.request.stop",
        tags: [:BBCEnvironment, :route_spec]
      ),
      summary(
        "webcore.request.duration",
        event_name: "belfrage.webcore.request.stop",
        unit: {:native, :millisecond},
        tags: [:BBCEnvironment, :route_spec]
      ),
      counter(
        "webcore.response",
        event_name: "belfrage.webcore.response",
        tags: [:status_code, :route_spec]
      ),
      counter(
        "webcore.error",
        event_name: "belfrage.webcore.error",
        tags: [:error_code, :route_spec]
      )
    ]

    # TODO: Remove these legacy metrics when they are no longer used on any
    # dashboards
    webcore_legacy =
      [
        summary(
          "function.timing.service.lambda.invoke",
          event_name: "belfrage.webcore.request.stop",
          measurement: :duration,
          unit: {:native, :millisecond},
          tags: [:BBCEnvironment]
        )
      ] ++
        Enum.map([200, 301, 302, 400, 404, 500, 502], fn status_code ->
          counter(
            "service.lambda.response.#{status_code}",
            event_name: "belfrage.webcore.response",
            keep: &(&1.status_code == status_code),
            tags: [:BBCEnvironment]
          )
        end) ++
        Enum.map(~w(invalid_web_core_contract function_not_found invoke_timeout invoke_failure)a, fn error_code ->
          counter(
            "service.lambda.response.#{error_code}",
            event_name: "belfrage.webcore.error",
            keep: &(&1.error_code == error_code),
            tags: [:BBCEnvironment]
          )
        end)

    webcore ++ webcore_legacy
  end

  defp plug_metrics() do
    metrics = [
      summary(
        "belfrage.request.duration",
        event_name: "belfrage.plug.stop",
        tag_values: &Map.merge(&1, %{status_code: &1.conn.status, route_spec: &1.conn.assigns[:route_spec]}),
        unit: {:native, :millisecond},
        tags: [:BBCEnvironment, :status_code, :route_spec]
      ),
      counter(
        "belfrage.response",
        event_name: "belfrage.plug.stop",
        tag_values: &Map.merge(&1, %{status_code: &1.conn.status, route_spec: &1.conn.assigns[:route_spec]}),
        tags: [:status_code, :route_spec]
      ),
      counter(
        "belfrage.response.private",
        event_name: "belfrage.plug.stop",
        keep: &(&1.conn.status == 200 && private_response?(&1.conn)),
        tag_values: &Map.put(&1, :route_spec, &1.conn.assigns[:route_spec]),
        tags: [:BBCEnvironment, :route_spec]
      ),
      counter(
        "befrage.response.stale",
        event_name: "belfrage.plug.stop",
        keep: &(Plug.Conn.get_resp_header(&1.conn, "belfrage-cache-status") == ["STALE"]),
        tag_values: &Map.put(&1, :route_spec, &1.conn.assigns[:route_spec]),
        tags: [:BBCEnvironment, :route_spec]
      ),
      counter(
        "belfrage.error",
        event_name: "plug.router_dispatch.exception",
        keep: &(&1.router == BelfrageWeb.Router),
        tag_values: fn metadata ->
          case metadata.reason do
            %{conn: conn} ->
              Map.put(metadata, :route_spec, conn.assigns[:route_spec])

            _ ->
              metadata
          end
        end,
        tags: [:BBCEnvironment, :route_spec]
      )
    ]

    # TODO: Remove these legacy metrics when they are no longer used on any
    # dashboards
    legacy_metrics =
      [
        counter(
          "web.request.count",
          event_name: "belfrage.plug.start",
          tags: [:BBCEnvironment]
        ),
        summary(
          "web.response.timing.page",
          event_name: "belfrage.plug.stop",
          measurement: :duration,
          unit: {:native, :millisecond},
          tags: [:BBCEnvironment]
        ),
        counter(
          "web.response.private",
          event_name: "belfrage.plug.stop",
          keep: &(&1.conn.status == 200 && private_response?(&1.conn)),
          tags: [:BBCEnvironment]
        )
      ] ++
        Enum.flat_map([200, 204, 301, 302, 400, 404, 405, 408, 500], fn status ->
          [
            counter(
              "web.response.status.#{status}",
              event_name: "belfrage.plug.stop",
              keep: &(&1.conn.status == status),
              tags: [:BBCEnvironment]
            ),
            summary(
              "web.response.timing.#{status}",
              event_name: "belfrage.plug.stop",
              measurement: :duration,
              unit: {:native, :millisecond},
              keep: &(&1.conn.status == status),
              tags: [:BBCEnvironment]
            )
          ]
        end)

    metrics ++ legacy_metrics
  end

  def private_response?(conn = %Plug.Conn{}) do
    match?(["private" <> _], Plug.Conn.get_resp_header(conn, "cache-control"))
  end
end
