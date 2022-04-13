defmodule Belfrage.Processor do
  require Logger

  alias Belfrage.{
    RouteStateRegistry,
    Struct,
    RouteState,
    Pipeline,
    RequestHash,
    Cache,
    ResponseTransformers,
    Allowlist,
    Personalisation,
    CacheControl,
    Metrics,
    Language,
    WrapperError
  }

  alias Struct.{Request, Response, Private}
  alias Belfrage.Metrics.LatencyMonitor

  def pre_request_pipeline(struct = %Struct{}) do
    pipeline = [
      &get_route_state/1,
      &allowlists/1,
      &Personalisation.maybe_put_personalised_request/1,
      &language/1,
      &generate_request_hash/1
    ]

    WrapperError.wrap(pipeline, struct)
  end

  def get_route_state(struct = %Struct{}) do
    Metrics.duration(:set_request_route_state_data, fn ->
      RouteStateRegistry.find_or_start(struct)

      case RouteState.state(struct) do
        {:ok, route_state} -> Map.put(struct, :private, Map.merge(struct.private, route_state))
        _ -> route_state_state_failure()
      end
    end)
  end

  def language(struct) do
    Language.add_signature(struct)
  end

  def allowlists(struct) do
    Metrics.duration(:filter_request_data, fn ->
      struct
      |> Personalisation.append_allowlists()
      |> Allowlist.QueryParams.filter()
      |> Allowlist.Cookies.filter()
      |> Allowlist.Headers.filter()
    end)
  end

  def generate_request_hash(struct = %Struct{}) do
    Metrics.duration(:generate_request_hash, fn ->
      RequestHash.put(struct)
    end)
  end

  def fetch_early_response_from_cache(struct = %Struct{private: private = %Private{}}) do
    if private.caching_enabled && !private.personalised_request do
      WrapperError.wrap(&do_fetch_early_response_from_cache/1, struct)
    else
      struct
    end
  end

  defp do_fetch_early_response_from_cache(struct = %Struct{}) do
    struct =
      Metrics.duration(:fetch_early_response_from_cache, fn ->
        Cache.fetch(struct, [:fresh])
      end)

    if struct.response.http_status do
      latency_checkpoint(struct, :early_response_received)
      RouteState.inc(struct)
    end

    struct
  end

  def request_pipeline(struct = %Struct{}) do
    Metrics.duration(:request_pipeline, fn ->
      WrapperError.wrap(&process_request_pipeline/1, struct)
    end)
  end

  defp process_request_pipeline(struct = %Struct{}) do
    case Pipeline.process(struct) do
      {:ok, struct} -> struct
      {:error, _struct, msg} -> raise "Pipeline failed #{msg}"
    end
  end

  def response_pipeline(struct = %Struct{}) do
    pipeline = [
      &inc_route_state/1,
      &maybe_log_response_status/1,
      &ResponseTransformers.CacheDirective.call/1,
      &ResponseTransformers.ResponseHeaderGuardian.call/1,
      &ResponseTransformers.PreCacheCompression.call/1,
      &ResponseTransformers.MvtMapper.call/1,
      &Cache.store/1,
      &fetch_fallback_from_cache/1
    ]

    WrapperError.wrap(pipeline, struct)
  end

  defp inc_route_state(struct = %Struct{}) do
    RouteState.inc(struct)
    struct
  end

  def fetch_fallback_from_cache(struct = %Struct{}) do
    if use_fallback?(struct) do
      struct =
        struct
        |> latency_checkpoint(:fallback_request_sent)
        |> Cache.fetch([:fresh, :stale])
        |> latency_checkpoint(:fallback_response_received)

      if struct.response.http_status == 200 do
        struct
        |> inc_route_state()
        |> Cache.store()
        |> make_fallback_private_if_personalised_request()
      else
        struct
      end
    else
      struct
    end
  end

  def use_fallback?(%Struct{
        response: %Response{http_status: status},
        private: %Private{caching_enabled: caching_enabled}
      }) do
    status >= 400 and status not in [401, 404, 410, 451] and caching_enabled
  end

  defp latency_checkpoint(struct = %Struct{request: request = %Request{}}, checkpoint) do
    LatencyMonitor.checkpoint(request.request_id, checkpoint)
    struct
  end

  defp make_fallback_private_if_personalised_request(
         struct = %Struct{
           private: private = %Private{}
         }
       ) do
    if private.personalised_request do
      Struct.add(struct, :response, %{cache_directive: CacheControl.private()})
    else
      struct
    end
  end

  def post_response_pipeline(struct = %Struct{}) do
    WrapperError.wrap(&ResponseTransformers.CompressionAsRequested.call/1, struct)
  end

  defp route_state_state_failure do
    Belfrage.Event.record(:metric, :increment, "error.route_state.state")

    Logger.log(:error, "Error retrieving route_state state")

    raise "Failed to load route_state state."
  end

  defp maybe_log_response_status(struct = %Struct{response: %Response{http_status: http_status}})
       when http_status in [404, 408] or http_status > 499 do
    Logger.log(:warn, "#{http_status} error from origin", cloudwatch: true)
    struct
  end

  defp maybe_log_response_status(struct), do: struct
end
