defmodule Belfrage.RequestHash do
  alias Belfrage.Struct
  @signature_keys [:country, :has_been_replayed?, :host, :method, :path, :query_params, :subdomain, :scheme]

  def generate(struct) do
    case Belfrage.Overrides.should_cache_bust?(struct) do
      true ->
        cache_bust_request_hash()

      false ->
        extract_keys(struct.request)
        |> Crimpex.signature()
    end
    |> update_struct(struct)
  end

  defp extract_keys(request) do
    Map.take(request, @signature_keys)
  end

  defp update_struct(request_hash, struct) do
    Struct.add(struct, :request, %{request_hash: request_hash})
  end

  defp cache_bust_request_hash do
    "cache-bust." <> UUID.uuid4()
  end
end
