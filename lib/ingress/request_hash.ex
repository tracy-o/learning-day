defmodule Ingress.RequestHash do
  @signature_keys [:path, :country]

  def generate(struct) do
    sanitise(struct.request)
    |> Crimpex.signature()
    |> update_struct(struct)
  end

  defp sanitise(request) do
    Map.take(request, @signature_keys)
  end

  defp update_struct(request_hash, struct) do
    request = Map.put(struct.request, :request_hash, request_hash)
    Map.put(struct, :request, request)
  end
end
