defmodule Ingress.RequestHash do
  @signature_keys [:path, :country]

  def generate(struct) do
    data = sanitise(struct.request)
    request_hash = Crimpex.signature(data)
    update_struct(struct, request_hash)
  end

  defp sanitise(request) do
    Map.take(request, @signature_keys)
  end

  defp update_struct(struct, request_hash) do
    request = Map.put(struct.request, :request_hash, request_hash)
    Map.put(struct, :request, request)
  end
end