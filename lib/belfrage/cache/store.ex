defmodule Belfrage.Cache.Store do
  alias Belfrage.Cache.MultiStrategy

  def store(struct) do
    if is_cacheable?(struct), do: MultiStrategy.store(struct)

    struct
  end

  defp is_cacheable?(struct) do
    is_successful_response?(struct) and is_get_request?(struct) and is_public_cacheable_response?(struct)
  end

  defp is_public_cacheable_response?(struct) do
    case struct.response.cache_directive do
      %{cacheability: "public", max_age: max_age} when max_age > 0 -> true
      _ -> false
    end
  end

  defp is_successful_response?(struct) do
    struct.response.http_status == 200
  end

  defp is_get_request?(struct) do
    struct.request.method == "GET"
  end
end
