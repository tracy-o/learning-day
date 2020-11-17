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
  alias Belfrage.Struct

  @struct %Struct{
    request: %Struct.Request{
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
    struct = @struct |> Belfrage.Struct.add(:request, %{raw_headers: %{}})

    Benchee.run(
      %{
        "prev: hash with empty raw headers" => fn -> generate(struct) end,
        "new: hash with empty raw headers" => fn -> RequestHash.generate(struct) end
      },
      time: 10,
      memory_time: 5
    )
  end

  ## previous implementation
  def generate(struct) do
    case Belfrage.Overrides.should_cache_bust?(struct) do
      true ->
        cache_bust_request_hash()

      false ->
        extract_keys(struct)
        |> Crimpex.signature()
    end
    |> update_struct(struct)
  end

  defp extract_keys(struct) do
    Map.take(struct.request, build_signature_keys(struct))
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

  defp build_signature_keys(%Struct{
         private: %Struct.Private{signature_keys: %{skip: skip_keys, add: add_keys}}
       }) do
    (@default_signature_keys ++ add_keys) -- skip_keys
  end

  defp update_struct(request_hash, struct) do
    Struct.add(struct, :request, %{request_hash: request_hash})
  end

  defp cache_bust_request_hash do
    "cache-bust." <> UUID.uuid4()
  end
end
