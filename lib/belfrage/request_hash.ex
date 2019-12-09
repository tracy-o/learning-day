defmodule Belfrage.RequestHash do
  alias Belfrage.Struct
  @signature_keys [:path, :country, :method, :query_params, :has_been_replayed?, :subdomain]

  def generate(struct) do
    extract_keys(struct.request)
    |> Crimpex.signature()
    |> update_struct(struct)
  end

  defp extract_keys(request) do
    Map.take(request, @signature_keys)
  end

  defp update_struct(request_hash, struct) do
    Struct.add(struct, :request, %{request_hash: request_hash})
  end
end
