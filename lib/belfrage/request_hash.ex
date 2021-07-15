defmodule Belfrage.RequestHash do
  alias Belfrage.Struct
  alias Belfrage.Struct.Private

  @signature_keys [
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

  @ignore_headers ~w(cookie x-id-oidc-signedin)

  def put(struct = %Struct{}) do
    Struct.add(struct, :request, %{request_hash: generate(struct)})
  end

  def generate(struct = %Struct{}) do
    if Belfrage.Overrides.should_cache_bust?(struct) do
      cache_bust_hash()
    else
      struct
      |> take_signature_keys()
      |> Crimpex.signature()
    end
  end

  defp cache_bust_hash() do
    "cache-bust." <> UUID.uuid4()
  end

  defp take_signature_keys(struct = %Struct{}) do
    struct.request
    |> Map.take(signature_keys(struct.private))
    |> filter_headers()
  end

  defp signature_keys(%Private{signature_keys: %{add: add, skip: skip}}) do
    (@signature_keys ++ add) -- skip
  end

  defp filter_headers(keys) do
    case keys do
      %{raw_headers: headers} when headers != %{} ->
        %{keys | raw_headers: Map.take(headers, signature_headers(headers))}

      _ ->
        keys
    end
  end

  defp signature_headers(headers) do
    Map.keys(headers) -- @ignore_headers
  end
end
