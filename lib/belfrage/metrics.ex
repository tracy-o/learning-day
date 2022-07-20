# credo:disable-for-this-file Credo.Check.Refactor.LongQuoteBlocks
defmodule Belfrage.Metrics do
  @moduledoc """
  This module should be used to emit telemetry events instead of calling
  `:telemetry` directly. It encapsulates our telemetry conventions.
  """

  @type event_name :: atom() | [atom()]
  @type start_time :: integer()
  @type measurements :: map()
  @type metadata :: map()

  @event_prefix :belfrage
  @time_unit :nanosecond

  @doc """
  Record a measurement. Name can be an atom or a list of atoms if the
  measurement needs to be prefixed. The measurement itself can be any map.
  """
  @spec measurement(event_name(), measurements(), metadata()) :: :ok
  def measurement(name, measurements, metadata \\ %{}), do: event(name, measurements, metadata)

  @doc """
  Measure duration of execution of the passed function. Emits the same event as
  `stop/3`.
  """
  @spec duration(event_name(), fun()) :: any()
  def duration(name, func), do: duration(name, %{}, func)

  @doc """
  Same as `duration/2` but accepts metadata as well.
  """
  @spec duration(event_name(), metadata(), fun()) :: any()
  def duration(name, metadata, func) do
    start_time = System.monotonic_time(@time_unit)
    result = func.()
    stop(name, start_time, metadata)
    result
  end

  @doc """
  Record an event with optional metadata.
  """
  @spec event(event_name(), metadata()) :: :ok
  def event(name, metadata \\ %{}), do: event(name, %{}, metadata)

  @doc """
  Records the end of an event span. Emits a `[prefix, name, :stop]` event with
  a `duration` measurement calculated using the passed `start_time` which must
  be the result of calling `System.monotonic_time/0` at the beginning of the
  event span.
  """
  @spec stop(event_name(), start_time(), metadata()) :: :ok
  def stop(name, start_time, metadata \\ %{}) do
    duration = System.monotonic_time(@time_unit) - start_time
    os_start_time = System.os_time(@time_unit) - duration

    name
    |> suffix_name(:stop)
    |> event(%{duration: duration, start_time: os_start_time}, metadata)
  end

  defp event(name, measurements, metadata) do
    name
    |> prefix_name()
    |> :telemetry.execute(measurements, metadata)

    :ok
  end

  defp prefix_name(name) do
    [@event_prefix | List.wrap(name)]
  end

  defp suffix_name(name, suffix) do
    List.wrap(name) ++ [suffix]
  end

  defmacro __using__(opts) do
    metrics = Keyword.get(opts, :metrics)

    quote do
      def metrics do
        unquote(metrics)
        |> Enum.flat_map(fn metric ->
          apply(__MODULE__, metric, [])
        end)
      end

      def vm_metrics() do
        [
          last_value("vm.memory.total", unit: {:byte, :kilobyte}),
          last_value("vm.system_counts.process_count"),
          last_value("vm.system_counts.atom_count"),
          last_value("vm.system_counts.port_count"),
          last_value("vm.total_run_queue_lengths.total"),
          last_value("vm.total_run_queue_lengths.cpu"),
          last_value("vm.total_run_queue_lengths.io")
        ]
      end

      def cowboy_metrics() do
        [
          summary("cowboy.request.stop.duration", unit: {:native, :millisecond}),
          counter("cowboy.request.exception.count"),
          counter("cowboy.request.early_error.count"),
          counter("cowboy.request.idle_timeout.count",
            event_name: "cowboy.request.stop",
            keep: &match?(%{error: {:connection_error, :timeout, _}}, &1)
          )
        ]
      end

      def poolboy_metrics() do
        [
          last_value("poolboy.available_workers.count",
            measurement: :available_workers,
            event_name: "belfrage.poolboy.status",
            tags: [:pool_name]
          ),
          last_value("poolboy.overflow_workers.count",
            measurement: :overflow_workers,
            event_name: "belfrage.poolboy.status",
            tags: [:pool_name]
          ),
          last_value("poolboy.pools.max_saturation",
            event_name: "belfrage.poolboy.pools"
          )
        ]
      end

      def nimble_pool_metrics() do
        [
          last_value("nimble_pool.available_workers.count",
            measurement: :available_workers,
            event_name: "belfrage.nimble_pool.status",
            tags: [:pool_name]
          ),
          last_value("nimble_pool.queued_requests.count",
            measurement: :queued_requests,
            event_name: "belfrage.nimble_pool.status",
            tags: [:pool_name]
          )
        ]
      end

      def cachex_metrics() do
        for measurement <- ~w(evictions expirations hits misses updates writes)a do
          last_value([:cachex, measurement],
            measurement: measurement,
            event_name: "belfrage.cachex.stats",
            tags: [:cache_name]
          )
        end
      end

      def latency_metrics() do
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
          fn name ->
            summary("belfrage.latency.#{name}",
              event_name: "belfrage.#{name}.stop",
              measurement: :duration,
              unit: {:native, :microsecond}
            )
          end
        )
      end

      def request_metrics() do
        Enum.map(~w(idcta_config jwk assume_webcore_lambda_role), fn name ->
          summary("belfrage.request.#{name}.duration",
            event_name: "belfrage.request.#{name}.stop",
            unit: {:native, :millisecond}
          )
        end)
      end

      def route_state_metrics() do
        [
          last_value("circuit_breaker.throughput",
            measurement: :throughput,
            event_name: "belfrage.circuit_breaker.throughput",
            tags: [:route_spec]
          ),
          counter("circuit_breaker.applied",
            event_name: "belfrage.circuit_breaker.applied",
            tags: [:route_spec]
          ),
          counter("circuit_breaker.open",
            event_name: "belfrage.circuit_breaker.open",
            tags: [:route_spec]
          )
        ]
      end

      def cache_metrics() do
        [counter("cache.local.fetch_exit")]
      end

      def service_metrics() do
        webcore = [
          counter(
            "webcore.request.count",
            event_name: "belfrage.webcore.request.stop",
            tags: [:route_spec]
          ),
          summary(
            "webcore.request.duration",
            event_name: "belfrage.webcore.request.stop",
            unit: {:native, :millisecond},
            tags: [:route_spec]
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
              unit: {:native, :millisecond}
            )
          ] ++
            Enum.map([200, 301, 302, 400, 404, 500, 502], fn status_code ->
              counter(
                "service.lambda.response.#{status_code}",
                event_name: "belfrage.webcore.response",
                keep: &(&1.status_code == status_code)
              )
            end) ++
            Enum.map(~w(invalid_web_core_contract function_not_found invoke_timeout invoke_failure)a, fn error_code ->
              counter(
                "service.lambda.response.#{error_code}",
                event_name: "belfrage.webcore.error",
                keep: &(&1.error_code == error_code)
              )
            end)

        webcore ++ webcore_legacy
      end

      def plug_metrics() do
        metrics = [
          summary(
            "belfrage.request.duration",
            event_name: "belfrage.plug.stop",
            tag_values: &Map.merge(&1, %{status_code: &1.conn.status, route_spec: &1.conn.assigns[:route_spec]}),
            unit: {:native, :millisecond},
            tags: [:status_code, :route_spec]
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
            tags: [:route_spec]
          ),
          counter(
            "befrage.response.stale",
            event_name: "belfrage.plug.stop",
            keep: &(Plug.Conn.get_resp_header(&1.conn, "belfrage-cache-status") == ["STALE"]),
            tag_values: &Map.put(&1, :route_spec, &1.conn.assigns[:route_spec]),
            tags: [:route_spec]
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
            tags: [:route_spec]
          )
        ]

        # TODO: Remove these legacy metrics when they are no longer used on any
        # dashboards
        legacy_metrics =
          [
            counter(
              "web.request.count",
              event_name: "belfrage.plug.start"
            ),
            summary(
              "web.response.timing.page",
              event_name: "belfrage.plug.stop",
              measurement: :duration,
              unit: {:native, :millisecond}
            ),
            counter(
              "web.response.private",
              event_name: "belfrage.plug.stop",
              keep: &(&1.conn.status == 200 && private_response?(&1.conn))
            )
          ] ++
            Enum.flat_map([200, 204, 301, 302, 400, 404, 405, 408, 500], fn status ->
              [
                counter(
                  "web.response.status.#{status}",
                  event_name: "belfrage.plug.stop",
                  keep: &(&1.conn.status == status)
                ),
                summary(
                  "web.response.timing.#{status}",
                  event_name: "belfrage.plug.stop",
                  measurement: :duration,
                  unit: {:native, :millisecond},
                  keep: &(&1.conn.status == status)
                )
              ]
            end)

        metrics ++ legacy_metrics
      end

      def misc_metrics() do
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
          counter(metric, event_name: event_name, tags: [:route_spec])
        end
      end

      def private_response?(conn = %Plug.Conn{}) do
        match?(["private" <> _], Plug.Conn.get_resp_header(conn, "cache-control"))
      end
    end
  end
end
