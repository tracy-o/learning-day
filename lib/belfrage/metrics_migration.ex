# credo:disable-for-this-file Credo.Check.Refactor.LongQuoteBlocks
# credo:disable-for-this-file Credo.Check.Refactor.CyclomaticComplexity
defmodule Belfrage.MetricsMigration do
  def route_specs_from_file_names() do
    Path.expand("../routes/specs", __DIR__)
    |> File.ls!()
    |> Enum.map(&Path.basename(&1, ".ex"))
    |> Enum.map(&Macro.camelize/1)
  end

  def platforms_from_file_names() do
    Path.expand("../routes/platforms", __DIR__)
    |> File.ls!()
    |> Enum.map(&Path.basename(&1, ".ex"))
    |> Enum.map(&Macro.camelize/1)
  end

  defmacro __using__(opts) do
    backend = Keyword.get(opts, :backend)
    metrics = Keyword.get(opts, :metrics)

    quote do
      @backend unquote(backend)
      @status_codes [200, 204, 301, 302, 400, 404, 405, 408, 500, 502]
      @route_states unquote(__MODULE__).route_specs_from_file_names()
      @platforms unquote(__MODULE__).platforms_from_file_names()
      @cache_metrics [:local, :distributed]

      def metrics do
        unquote(metrics)
        |> Enum.flat_map(fn metric ->
          apply(__MODULE__, metric, [])
        end)
      end

      def statix_static_metrics() do
        dont_have_dimensions =
          [
            counter("route_state.state.fetch.timeout",
              event_name: [:belfrage, :route_state, :fetch, :timeout],
              measurement: :count
            ),
            counter("http.pools.error.timeout",
              event_name: [:belfrage, :http, :pools, :error, :timeout],
              measurement: :count
            ),
            counter("http.client.error",
              event_name: [:belfrage, :http, :client, :error],
              measurement: :count
            ),
            summary("service.S3.request.timing",
              event_name: [:belfrage, :service, :S3, :request, :timing],
              measurement: :duration
            ),
            counter("service.S3.response.not_found",
              event_name: [:belfrage, :service, :S3, :response, :not_found],
              measurement: :count
            ),
            counter("web.response.fallback",
              event_name: [:belfrage, :web, :response, :fallback],
              measurement: :count
            ),
            counter("request.personalised.unexpected_public_response",
              event_name: [:belfrage, :request, :personalised, :unexpected_public_response],
              measurement: :count
            ),
            counter("error.process.crash",
              event_name: [:belfrage, :error, :process, :crash],
              measurement: :count
            )
          ] ++
            for platform <- @platforms do
              summary("function.timing.service.#{platform}.request",
                event_name: "belfrage.function.timing.service.#{platform}.request.stop",
                measurement: :duration
              )
            end ++
            for type <- ~w(request response combined)a do
              summary("web.latency.internal.#{type}",
                event_name: [:belfrage, :web, :latency, :internal, type],
                measurement: :duration
              )
            end

        have_dimensions =
          case @backend do
            :statsd ->
              for route_state <- @route_states,
                  cache_metric <- @cache_metrics do
                counter("cache.#{route_state}.#{cache_metric}.stale.hit",
                  event_name: "belfrage.cache.#{route_state}.#{cache_metric}.stale.hit",
                  measurement: :count
                )
              end ++
                for platform <- @platforms do
                  counter("#{platform}.pre_cache_compression",
                    event_name: "belfrage.#{platform}.pre_cache_compression",
                    measurement: :count
                  )
                end ++
                for platform <- @platforms do
                  summary("function.timing.#{platform}.request",
                    event_name: "belfrage.function.timing.#{platform}.request",
                    measurement: :duration
                  )
                end

            :prometheus ->
              [
                counter("cache.stale.hit",
                  event_name: [:belfrage, :cache, :stale, :hit],
                  measurement: :count,
                  tags: [:route_state, :cache_metric]
                ),
                counter("pre_cache_compression",
                  event_name: [:belfrage, :pre_cache_compression],
                  measurement: :count,
                  tags: [:platform]
                )
              ]
          end

        dont_have_dimensions ++ have_dimensions
      end

      def statix_dynamic_metrics() do
        case @backend do
          :statsd ->
            for status_code <- @status_codes do
              counter("service.S3.response.#{status_code}",
                event_name: "belfrage.service.S3.response.#{status_code}",
                measurement: :count
              )
            end ++
              for status_code <- @status_codes do
                counter("service.Fabl.response.#{status_code}",
                  event_name: "belfrage.service.Fabl.response.#{status_code}",
                  measurement: :count
                )
              end

          :prometheus ->
            [
              counter("service.S3.response",
                event_name: [:belfrage, :service, :S3, :response],
                measurement: :count,
                tags: [:status_code]
              ),
              counter("service.Fabl.response",
                event_name: [:belfrage, :Fabl, :response],
                measurement: :count,
                tags: [:status_code]
              )
            ]
        end
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
        for measurement <- Belfrage.Metrics.Cachex.measurements() do
          last_value([:cachex, measurement],
            measurement: measurement,
            event_name: "belfrage.cachex.stats",
            tags: [:cache_name]
          )
        end
      end

      def latency_metrics() do
        case @backend do
          :statsd ->
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

          :prometheus ->
            [
              summary("belfrage.latency",
                event_name: "belfrage.latency.stop",
                measurement: :duration,
                unit: {:native, :microsecond},
                tags: [:function_name]
              )
            ]
        end
      end

      def request_metrics() do
        case @backend do
          :statsd ->
            Enum.map(~w(idcta_config jwk assume_webcore_lambda_role), fn name ->
              summary("belfrage.request.#{name}.duration",
                event_name: "belfrage.request.#{name}.stop",
                unit: {:native, :millisecond}
              )
            end)

          :prometheus ->
            [
              summary("belfrage.request.duration",
                event_name: "belfrage.request.stop",
                unit: {:native, :millisecond},
                tags: [:authentication_type]
              )
            ]
        end
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

      def webcore_metrics() do
        [
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
      end

      def webcore_legacy_metrics() do
        # TODO: Remove these legacy metrics when they are no longer used on any
        # dashboards
        [
          summary(
            "function.timing.service.lambda.invoke",
            event_name: "belfrage.webcore.request.stop",
            measurement: :duration,
            unit: {:native, :millisecond}
          )
        ] ++
          Enum.map(@status_codes, fn status_code ->
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
      end

      def plug_metrics() do
        [
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
      end

      def plug_legacy_metrics() do
        # TODO: Remove these legacy metrics when they are no longer used on any
        # dashboards
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
          Enum.flat_map(@status_codes, fn status ->
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
