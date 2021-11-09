defmodule Belfrage.Processor do
  alias Belfrage.{
    LoopsRegistry,
    Struct,
    Loop,
    Pipeline,
    RequestHash,
    Cache,
    ResponseTransformers,
    Allowlist,
    Event,
    Personalisation,
    CacheControl,
    Metrics,
    Language
  }

  alias Struct.{Request, Response, Private}
  alias Belfrage.Metrics.LatencyMonitor

  def pre_request_pipeline(struct = %Struct{}) do
    struct
    |> get_loop()
    |> allowlists()
    |> personalisation()
    |> language()
    |> generate_request_hash()
  end

  def get_loop(struct = %Struct{}) do
    Metrics.duration(:set_request_loop_data, fn ->
      LoopsRegistry.find_or_start(struct)

      case Loop.state(struct) do
        {:ok, loop} -> Map.put(struct, :private, Map.merge(struct.private, loop))
        _ -> loop_state_failure()
      end
    end)
  end

  def personalisation(struct = %Struct{}) do
    Metrics.duration(:check_if_personalised_request, fn ->
      Struct.add(struct, :private, %{personalised_request: Personalisation.personalised_request?(struct)})
    end)
  end

  def language(struct) do
    Language.add_signature(struct)
  end

  def allowlists(struct) do
    Metrics.duration(:filter_request_data, fn ->
      struct
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

  def fetch_early_response_from_cache(
        struct = %Struct{private: %Private{personalised_request: personalised, caching_enabled: caching_enabled}}
      ) do
    case {personalised, caching_enabled} do
      {false, true} ->
        struct =
          Metrics.duration(:fetch_early_response_from_cache, fn ->
            Cache.fetch(struct, [:fresh])
          end)

        if struct.response.http_status do
          latency_checkpoint(struct, :early_response_received)
          Loop.inc(struct)
        end

        struct

      _ ->
        struct
    end
  end

  def request_pipeline(struct = %Struct{}) do
    Metrics.duration(:request_pipeline, fn ->
      case Pipeline.process(struct) do
        {:ok, struct} -> struct
        {:error, _struct, msg} -> raise "Pipeline failed #{msg}"
      end
    end)
  end

  def response_pipeline(struct = %Struct{}) do
    Loop.inc(struct)

    struct
    |> maybe_log_response_status()
    |> ResponseTransformers.CacheDirective.call()
    |> ResponseTransformers.ResponseHeaderGuardian.call()
    |> ResponseTransformers.PreCacheCompression.call()
    |> Cache.store()
    |> fetch_fallback_from_cache()
  end

  def fetch_fallback_from_cache(struct = %Struct{}) do
    if use_fallback?(struct) do
      struct =
        struct
        |> latency_checkpoint(:fallback_request_sent)
        |> Cache.fetch([:fresh, :stale])
        |> latency_checkpoint(:fallback_response_received)

      if struct.response.http_status == 200 do
        Loop.inc(struct)

        struct
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
    status >= 400 and status not in [404, 410, 451] and caching_enabled
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
    ResponseTransformers.CompressionAsRequested.call(struct)
  end

  defp loop_state_failure do
    Belfrage.Event.record(:metric, :increment, "error.loop.state")

    Belfrage.Event.record(:log, :error, "Error retrieving loop state")

    raise "Failed to load loop state."
  end

  defp maybe_log_response_status(struct = %Struct{response: %Response{http_status: http_status}})
       when http_status in [404, 408] or http_status > 499 do
    Event.record(:log, :warn, "#{http_status} error from origin", cloudwatch: true)
    struct
  end

  defp maybe_log_response_status(struct), do: struct
end
