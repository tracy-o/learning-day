defmodule Benchmark.RequestHash do
  @moduledoc """
  Comparing previous and new implementation of
  `Belfrage.RequestHash.generate/1` that remove
   disallowed vary headers, i.e. cookie from raw_headers.

  This benchmark measures the performance when capability
  team adds custom vary headers in route spec and Belfrage
  use raw_headers in request hashing.

  The test also involves "cookie" header that is removed
  from request hashing and assesses the cost of doing so.

  ### To run this experiment
  ```
    $ mix benchmark request_hash # default 2 headers
    $ mix benchmark request_hash 5 # 5 headers
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

  def run([header_size]), do: experiment(header_size |> String.to_integer())
  def run(_), do: experiment()

  def experiment(header_size \\ 2) do
    {:ok, _started} = Application.ensure_all_started(:belfrage)

    base_headers =
      for _ <- 1..header_size, into: %{} do
        {string(8), string(30)}
      end

    headers_with_cookie = Map.merge(base_headers, %{"cookie" => string(30)})

    struct = @struct |> Belfrage.Struct.add(:request, %{raw_headers: %{}})
    struct_headers = @struct |> Belfrage.Struct.add(:request, %{raw_headers: base_headers})
    struct_headers_cookie = @struct |> Belfrage.Struct.add(:request, %{raw_headers: headers_with_cookie})

    Benchee.run(
      %{
        "prev: empty raw headers" => fn -> generate(struct) end,
        "prev: #{map_size(base_headers)} raw headers" => fn -> generate(struct_headers) end,
        "prev: #{map_size(headers_with_cookie)} raw headers and cookie" => fn -> generate(struct_headers_cookie) end,
        "new: empty raw headers" => fn -> RequestHash.generate(struct) end,
        "new: #{map_size(base_headers)} raw headers" => fn -> RequestHash.generate(struct_headers) end,
        "new: #{map_size(headers_with_cookie)} raw headers and cookie" => fn ->
          RequestHash.generate(struct_headers_cookie)
        end
      },
      time: 10,
      memory_time: 5
    )
  end

  defp string(size_in_bytes) do
    :crypto.strong_rand_bytes(size_in_bytes)
    |> Base.encode64()
    |> binary_part(0, size_in_bytes)
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
