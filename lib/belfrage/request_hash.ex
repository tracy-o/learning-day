defmodule Belfrage.RequestHash do
  alias Belfrage.Struct
  alias BelfrageWeb.ResponseHeaders.Vary

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

  def put(struct = %Struct{}) do
    Struct.add(struct, :request, %{request_hash: generate(struct)})
  end

  def generate(struct = %Struct{}) do
    if Belfrage.Overrides.should_cache_bust?(struct) do
      cache_bust_request_hash()
    else
      extract_keys(struct)
      |> remove_disallow_vary_headers()
      |> Crimpex.signature()
    end
  end

  defp remove_disallow_vary_headers(keys)
  defp remove_disallow_vary_headers(keys = %{raw_headers: headers}) when headers == %{}, do: keys

  defp remove_disallow_vary_headers(keys = %{raw_headers: headers}) do
    %{keys | raw_headers: Map.split(headers, Vary.disallow_headers()) |> elem(1)}
  end

  defp extract_keys(struct) do
    Map.take(struct.request, build_signature_keys(struct))
  end

  defp build_signature_keys(%Struct{
         private: %Struct.Private{signature_keys: %{skip: skip_keys, add: add_keys}}
       }) do
    (@default_signature_keys ++ add_keys) -- skip_keys
  end

  defp cache_bust_request_hash do
    "cache-bust." <> UUID.uuid4()
  end
end
