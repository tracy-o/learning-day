defmodule Belfrage.Processor do
  require Logger

  alias Belfrage.{
    Allowlist,
    Behaviours.Service,
    Cache,
    CacheControl,
    Envelope,
    Envelope.Private,
    Envelope.Response,
    Language,
    Metrics,
    Metrics.LatencyMonitor,
    Mvt,
    Personalisation,
    Pipeline,
    RequestHash,
    ResponseTransformers,
    RouteSpecManager,
    RouteState,
    RouteStateRegistry,
    WrapperError
  }

  def pre_request_pipeline(envelope = %Envelope{}) do
    pipeline = [
      &get_route_spec/1,
      &get_route_state/1,
      &allowlists/1,
      &Personalisation.maybe_put_personalised_request/1,
      &Language.add_signature/1,
      &Mvt.Mapper.map/1,
      &Belfrage.Xray.Enable.call/1,
      &generate_request_hash/1,
      &Mvt.Headers.remove_original_headers/1,
      &maybe_fetch_fallback/1
    ]

    WrapperError.wrap(pipeline, envelope)
  end

  def get_route_spec(envelope = %Envelope{private: %Private{spec: spec_name}}) do
    case RouteSpecManager.get_spec(spec_name) do
      nil ->
        route_spec_not_found_failure(spec_name)

      %{specs: specs, preflight_pipeline: []} ->
        update_envelope_with_spec(envelope, specs)

      %{specs: specs, preflight_pipeline: pipeline} ->
        start_preflight_pipeline(envelope, specs, pipeline)
    end
  end

  defp start_preflight_pipeline(envelope, specs, pipeline) do
    envelope
    |> LatencyMonitor.checkpoint(:preflight_request_begin)
    |> process_preflight_pipeline(specs, pipeline)
    |> LatencyMonitor.checkpoint(:preflight_request_end)
  end

  defp process_preflight_pipeline(envelope, specs, pipeline) do
    case Pipeline.process(envelope, :preflight, pipeline) do
      {:ok, envelope} ->
        update_envelope_with_spec(envelope, specs)

      {:error, envelope, msg} ->
        envelope = Envelope.add(envelope, :response, %{http_status: get_pipeline_fail_status(msg)})

        case specs do
          [_spec] -> update_envelope_with_spec(envelope, specs)
          specs -> merge_platform_allowlists(envelope, specs)
        end
    end
  end

  defp update_envelope_with_spec(envelope = %Envelope{private: private}, [spec])
       when private.platform in [nil, spec.platform] do
    update_envelope_with_route_spec_attrs(envelope, spec)
  end

  defp update_envelope_with_spec(envelope = %Envelope{private: private}, specs)
       when private.platform != nil do
    matched_specs = for spec <- specs, spec.platform == private.platform, do: spec

    case matched_specs do
      [] ->
        match_platform_failure(private.spec, private.platform)

      [spec] ->
        envelope
        |> update_envelope_with_route_spec_attrs(spec)
        |> merge_platform_allowlists(specs)
    end
  end

  defp update_envelope_with_spec(%Envelope{private: private}, _specs) do
    match_platform_failure(private.spec, private.platform)
  end

  defp update_envelope_with_route_spec_attrs(envelope = %Envelope{private: private}, spec) do
    route_state_id = make_route_state_id(private.spec, spec.platform, private.partition)
    spec = Map.put(spec, :route_state_id, route_state_id)
    Map.put(envelope, :private, struct(private, spec))
  end

  defp make_route_state_id(spec, platform, nil), do: {spec, platform}
  defp make_route_state_id(spec, platform, partition), do: {spec, platform, partition}

  def get_route_state(envelope) when envelope.private.route_state_id == nil do
    envelope
  end

  def get_route_state(
        envelope = %Envelope{
          private: %Private{
            route_state_id: route_state_id,
            origin: origin,
            circuit_breaker_error_threshold: threshold
          }
        }
      ) do
    route_state_args = %{
      origin: origin,
      circuit_breaker_error_threshold: threshold
    }

    Metrics.latency_span(:set_request_route_state_data, fn ->
      RouteStateRegistry.find_or_start(route_state_id, route_state_args)

      case RouteState.state(route_state_id) do
        {:ok, route_state} -> Map.put(envelope, :private, struct(envelope.private, route_state))
        {:error, reason} -> route_state_state_failure(reason)
      end
    end)
  end

  def allowlists(envelope) do
    Metrics.latency_span(:filter_request_data, fn ->
      envelope
      |> Personalisation.append_allowlists()
      |> maybe_add_mvt_allowlists()
      |> Allowlist.QueryParams.filter()
      |> Allowlist.Cookies.filter()
      |> Allowlist.Headers.filter()
    end)
  end

  defp maybe_add_mvt_allowlists(envelope) when envelope.private.route_state_id == nil, do: envelope
  defp maybe_add_mvt_allowlists(envelope), do: Mvt.Allowlist.add(envelope)

  defp merge_platform_allowlists(envelope, specs) do
    Envelope.add(envelope, :private, %{
      query_params_allowlist: get_platform_allowlist(specs, :query_params_allowlist),
      headers_allowlist: get_platform_allowlist(specs, :headers_allowlist)
    })
  end

  defp get_platform_allowlist(specs, type) do
    Enum.reduce_while(specs, [], fn spec, acc ->
      case Map.get(spec, type, []) do
        "*" -> {:halt, "*"}
        allowlist -> {:cont, Enum.uniq(acc ++ allowlist)}
      end
    end)
  end

  def generate_request_hash(envelope = %Envelope{}) do
    Metrics.latency_span(:generate_request_hash, fn ->
      RequestHash.put(envelope)
    end)
  end

  def fetch_early_response_from_cache(envelope = %Envelope{private: private = %Private{}}) do
    if private.caching_enabled && !private.personalised_request do
      WrapperError.wrap(&do_fetch_early_response_from_cache/1, envelope)
    else
      envelope
    end
  end

  defp do_fetch_early_response_from_cache(envelope = %Envelope{}) do
    envelope =
      Metrics.latency_span(:fetch_early_response_from_cache, fn ->
        Cache.fetch(envelope, [:fresh])
      end)

    if envelope.response.http_status do
      envelope = LatencyMonitor.checkpoint(envelope, :early_response_received)
      RouteState.inc(envelope)
      envelope
    else
      envelope
    end
  end

  def request_pipeline(envelope = %Envelope{}) do
    Metrics.latency_span(:request_pipeline, fn ->
      WrapperError.wrap(&process_request_pipeline/1, envelope)
    end)
  end

  def perform_call(envelope) when is_integer(envelope.response.http_status), do: envelope
  def perform_call(envelope), do: WrapperError.wrap(&Service.dispatch/1, envelope)

  def process_response_pipeline(envelope), do: process_pipeline(envelope, :response, envelope.private.response_pipeline)

  defp process_request_pipeline(envelope), do: process_pipeline(envelope, :request, envelope.private.request_pipeline)

  defp process_pipeline(envelope = %Envelope{private: private}, type, pipeline) do
    case Pipeline.process(envelope, type, pipeline) do
      {:ok, envelope} -> envelope
      {:error, _envelope, msg} -> raise "#{type} pipeline for '#{private.spec}' spec failed: #{msg}"
    end
  end

  def response_pipeline(envelope = %Envelope{}) do
    pipeline = [
      # ResponseTransformers.CachingEnabled.call/1 will inspect :mvt_seen,
      # which is updated by &update_route_state/1. Therefore we
      # need to call the former before the latter, as we would
      # like to get the state of :mvt_seen before it is
      # updated.
      unwrap_ok_response(&ResponseTransformers.CachingEnabled.call/1),
      &update_route_state/1,
      &maybe_log_response_status/1,
      &process_response_pipeline/1,
      &Cache.store/1,
      &fetch_fallback_from_cache/1
    ]

    WrapperError.wrap(pipeline, envelope)
  end

  defp inc_route_state(envelope = %Envelope{}) do
    RouteState.inc(envelope)
    envelope
  end

  defp update_route_state(envelope = %Envelope{}) do
    RouteState.update(envelope)
    envelope
  end

  defp maybe_fetch_fallback(envelope) do
    if envelope.response.http_status do
      fetch_fallback_from_cache(envelope)
    else
      envelope
    end
  end

  def fetch_fallback_from_cache(envelope = %Envelope{}) do
    if use_fallback?(envelope) do
      envelope =
        envelope
        |> LatencyMonitor.checkpoint(:fallback_request_sent)
        |> Cache.fetch([:fresh, :stale], fallback: true)
        |> LatencyMonitor.checkpoint(:fallback_response_received)

      if envelope.response.http_status == 200 do
        envelope
        |> inc_route_state()
        |> Cache.store()
        |> make_fallback_private_if_personalised_request()
      else
        envelope
      end
    else
      envelope
    end
  end

  def use_fallback?(%Envelope{
        response: %Response{http_status: status},
        private: %Private{caching_enabled: caching_enabled}
      }) do
    status >= 400 and status not in [401, 404, 410, 451] and caching_enabled
  end

  defp make_fallback_private_if_personalised_request(
         envelope = %Envelope{
           private: private = %Private{}
         }
       ) do
    if private.personalised_request do
      Envelope.add(envelope, :response, %{cache_directive: CacheControl.private()})
    else
      envelope
    end
  end

  def post_response_pipeline(envelope = %Envelope{}) do
    pipeline = [
      unwrap_ok_response(&ResponseTransformers.MvtMapper.call/1),
      unwrap_ok_response(&ResponseTransformers.CompressionAsRequested.call/1)
    ]

    WrapperError.wrap(pipeline, envelope)
  end

  defp route_state_state_failure(reason) do
    :telemetry.execute([:belfrage, :error, :route_state, :state], %{})
    Logger.log(:error, "Error retrieving route_state state with reason: #{inspect(reason)}}")
    raise "Failed to load route_state state."
  end

  defp route_spec_not_found_failure(spec) do
    :telemetry.execute([:belfrage, :route_spec, :not_found], %{}, %{route_spec: spec})
    reason = "Route spec '#{spec}' not found"
    Logger.log(:error, "", %{msg: reason})
    raise reason
  end

  defp match_platform_failure(spec, platform) do
    :telemetry.execute([:belfrage, :platform, :not_matched], %{}, %{route_spec: spec, platform: platform})
    reason = "Platform '#{platform}' cannot be matched in '#{spec}' spec"
    Logger.log(:error, "", %{msg: reason})
    raise reason
  end

  defp maybe_log_response_status(envelope = %Envelope{response: %Response{http_status: http_status}})
       when http_status in [404, 408] or http_status > 499 do
    Logger.log(:warn, "#{http_status} error from origin", cloudwatch: true)
    envelope
  end

  defp maybe_log_response_status(envelope), do: envelope

  defp get_pipeline_fail_status(code) when is_integer(code), do: code
  defp get_pipeline_fail_status(_msg), do: 500

  defp unwrap_ok_response(func) do
    fn envelope ->
      {:ok, resp} = func.(envelope)
      resp
    end
  end
end
