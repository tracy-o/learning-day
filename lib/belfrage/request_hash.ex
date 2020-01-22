defmodule Belfrage.RequestHash do
  alias Belfrage.Struct
  @signature_keys [:path, :country, :method, :query_params, :has_been_replayed?, :subdomain]

  def generate(struct) do
    extract_keys(struct.request)
    |> maybe_cache_bust(struct)
    |> Crimpex.signature()
    |> update_struct(struct)
  end

  defp extract_keys(request) do
    Map.take(request, @signature_keys)
  end

  defp update_struct(request_hash, struct) do
    Struct.add(struct, :request, %{request_hash: request_hash})
  end

  defp maybe_cache_bust(signature_keys, struct) do
    case Belfrage.Overrides.should_cache_bust?(struct) do
      true ->
        Map.put(signature_keys, :cache_bust_override, cache_bust_key())

      false ->
        signature_keys
    end
  end

  defp cache_bust_key do
    Integer.to_string(:rand.uniform(5_000_000))
  end
end
