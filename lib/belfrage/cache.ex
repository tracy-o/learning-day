defmodule Belfrage.Cache do
  alias Belfrage.Struct
  alias Belfrage.Cache.MultiStrategy

  def put(struct) do
    if is_cacheable?(struct), do: MultiStrategy.store(struct)

    struct
  end

  def get_fallback_on_error(struct = %Struct{}) do
    case server_error?(struct) or request_timeout_error?(struct) do
      true -> get(struct, [:fresh, :stale])
      false -> struct
    end
  end

  def get(struct, accepted_freshness) do
    Belfrage.Cache.MultiStrategy.fetch(struct, accepted_freshness)
    |> case do
      {:ok, freshness, response} ->
        add_response_to_struct(struct, freshness, response)

      {:ok, :content_not_found} ->
        struct
    end
  end

  defp add_response_to_struct(struct, freshness, response) do
    case freshness do
      :stale ->
        Struct.add(struct, :response, response) |> Struct.add(:response, %{fallback: true})

      :fresh ->
        Struct.add(struct, :response, response) |> Struct.add(:private, %{origin: :belfrage_cache})
    end
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

  defp server_error?(struct) do
    struct.response.http_status >= 500
  end

  defp request_timeout_error?(struct) do
    struct.response.http_status == 408
  end

  defp is_get_request?(struct) do
    struct.request.method == "GET"
  end
end
