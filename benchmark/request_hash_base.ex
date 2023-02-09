defmodule Benchmark.RequestHashBase do
  @moduledoc """
  Comparing previous and new implementation of
  `Belfrage.RequestHash.generate/1` that remove
   disallowed vary headers, i.e. cookie from raw_headers.

  This benchmark measures the performance
  of both implementations when raw_headers is empty %{}.

  ### To run this experiment
  ```
    $ mix benchmark request_hash_base
  ```
  """

  alias Belfrage.RequestHash
  alias Belfrage.Envelope

  @envelope %Envelope{
    request: %Envelope.Request{
      scheme: :https,
      path: "/news/clips/abc123",
      country: "gb",
      method: "GET",
      has_been_replayed?: false
    }
  }

  def run(_), do: experiment()

  def experiment() do
    {:ok, _started} = Application.ensure_all_started(:belfrage)
    envelope = @envelope |> Belfrage.Envelope.add(:request, %{raw_headers: %{}})

    Benchee.run(
      %{
        "prev: hash with empty raw headers" => fn -> generate(envelope) end,
        "new: hash with empty raw headers" => fn -> RequestHash.generate(envelope) end
      },
      time: 10,
      memory_time: 5
    )
  end

  ## previous implementation
  def generate(envelope) do
    case Belfrage.Overrides.should_cache_bust?(envelope) do
      true ->
        cache_bust_request_hash()

      false ->
        extract_keys(envelope)
        |> Crimpex.signature()
    end
    |> update_envelope(envelope)
  end

  defp extract_keys(envelope) do
    Map.take(envelope.request, build_signature_keys(envelope))
  end

  @default_signature_keys [
    :raw_headers,
    :query_params,
    :country,
    :has_been_replayed?,
    :origin_simulator?,
    :host,
    :is_uk,
    :method,
    :path,
    :scheme,
    :cdn?
  ]

  defp build_signature_keys(%Envelope{
         private: %Envelope.Private{signature_keys: %{skip: skip_keys, add: add_keys}}
       }) do
    (@default_signature_keys ++ add_keys) -- skip_keys
  end

  defp update_envelope(request_hash, envelope) do
    Envelope.add(envelope, :request, %{request_hash: request_hash})
  end

  defp cache_bust_request_hash do
    "cache-bust." <> UUID.uuid4()
  end
end
