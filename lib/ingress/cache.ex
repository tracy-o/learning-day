defmodule Ingress.Cache do
  alias Ingress.Struct
  alias Ingress.Cache.Local

  def store_if_successful(struct) do
    if is_cacheable?(struct), do: Local.store(struct)

    struct
  end

  def fallback_if_required(struct = %Ingress.Struct{}) do
    case is_successful_response?(struct) do
      true -> struct
      false -> add_response_from_cache(struct, [:fresh, :stale])
    end
  end

  def add_response_from_cache(struct, accepted_freshness) do
    with {:ok, freshness, response} <- Local.fetch(struct),
         true <- freshness in accepted_freshness do
      Struct.add(struct, :response, response)
    else
      _ -> struct
    end
  end

  defp is_cacheable?(struct) do
    is_successful_response?(struct) and is_get_request?(struct) and
      struct.response.cacheable_content
  end

  defp is_successful_response?(struct) do
    struct.response.http_status == 200
  end

  defp is_get_request?(struct) do
    struct.request.method == "GET"
  end
end
