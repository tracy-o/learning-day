defmodule Belfrage.Processor do
  alias Belfrage.{
    LoopsRegistry,
    Struct,
    Loop,
    Pipeline,
    RequestHash,
    ServiceProvider,
    Cache,
    ResponseTransformers
  }

  def get_loop(struct = %Struct{}) do
    LoopsRegistry.find_or_start(struct)

    case Loop.state(struct) do
      {:ok, loop} -> Map.put(struct, :private, Map.merge(struct.private, loop))
      _ -> loop_state_failure()
    end
  end

  def allowlists(struct) do
    struct
    |> Belfrage.QueryParams.allowlist()
    |> Belfrage.Headers.allowlist()
  end

  def generate_request_hash(struct = %Struct{}) do
    RequestHash.generate(struct)
  end

  def query_cache_for_early_response(struct = %Struct{}) do
    Cache.fetch(struct, [:fresh])
  end

  def request_pipeline(struct = %Struct{}) do
    case Pipeline.process(struct) do
      {:ok, struct} -> struct
      {:redirect, struct} -> struct
      {:error, _struct, msg} -> raise "Pipeline failed #{msg}"
    end
  end

  def perform_call(struct = %Struct{response: %Struct.Response{http_status: code}}) when is_number(code) do
    struct
  end

  def perform_call(struct = %Struct{private: %Struct.Private{origin: origin}}) do
    ServiceProvider.service_for(origin).dispatch(struct)
  end

  def response_pipeline(struct = %Struct{}) do
    struct
    |> ResponseTransformers.CacheDirective.call()
    |> ResponseTransformers.ResponseHeaderGuardian.call()
    |> ResponseTransformers.PreCacheCompression.call()
    |> Cache.store()
    |> Cache.fetch_fallback_on_error()
  end

  def init_post_response_pipeline(struct = %Struct{}) do
    Loop.inc(struct)

    struct
    |> ResponseTransformers.CompressionAsRequested.call()
  end

  defp loop_state_failure do
    ExMetrics.increment("error.loop.state")
    Stump.log(:error, "Error retrieving loop state")
    raise "Failed to load loop state."
  end
end
