defmodule Belfrage.Processor do
  alias Belfrage.{
    LoopsRegistry,
    Struct,
    Loop,
    Pipeline,
    RequestHash,
    ServiceProvider,
    Cache,
    ResponseTransformers,
    Allowlist,
    Event,
    RouteSpec.Personalisation
  }

  alias Struct.{Response, Private}

  def get_loop(struct = %Struct{}) do
    LoopsRegistry.find_or_start(struct)

    case Loop.state(struct) do
      {:ok, loop} -> Map.put(struct, :private, Map.merge(struct.private, loop))
      _ -> loop_state_failure()
    end
  end

  def personalisation(struct = %Struct{}) do
    Struct.add(struct, :private, %{personalised: Personalisation.personalisation_enabled?(struct.private.loop_id)})
  end

  def allowlists(struct) do
    struct
    |> Allowlist.QueryParams.filter()
    |> Allowlist.Cookies.filter()
    |> Allowlist.Headers.filter()
  end

  def generate_request_hash(struct = %Struct{}) do
    RequestHash.generate(struct)
  end

  def fetch_early_response_from_cache(struct = %Struct{private: private = %Private{}}) do
    if private.personalisation do
      struct
    else
      Cache.fetch(struct, [:fresh])
    end
  end

  def request_pipeline(struct = %Struct{}) do
    case Pipeline.process(struct) do
      {:ok, struct} -> struct
      {:error, _struct, msg} -> raise "Pipeline failed #{msg}"
    end
  end

  def perform_call(struct = %Struct{response: %Response{http_status: code}}) when is_number(code) do
    struct
  end

  # when only one struct
  def perform_call([struct = %Struct{private: %Private{origin: origin}}]) do
    ServiceProvider.service_for(origin).dispatch(struct)
  end

  @doc """
  When a list of structs, call the cascade service
  """
  def perform_call(structs) do
    Belfrage.Services.Cascade.dispatch(structs)
  end

  def response_pipeline(struct = %Struct{}) do
    struct
    |> maybe_log_response_status()
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
