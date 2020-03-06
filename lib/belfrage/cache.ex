defmodule Belfrage.Cache do
  alias Belfrage.Struct
  alias Belfrage.Cache.{Local, CCP}

  def store_if_successful(struct) do
    if is_cacheable?(struct), do: write_to_cache_stores(struct)

    struct
  end

  def fallback_if_required(struct = %Belfrage.Struct{}) do
    case is_successful_response?(struct) do
      true -> struct
      false -> add_response_from_cache(struct, [:fresh, :stale])
    end
  end

  def add_response_from_cache(struct, accepted_freshness) do
    with {:ok, freshness, response} <- Local.fetch(struct),
         true <- freshness in accepted_freshness do
      metric_stale_response(freshness, struct)
      add_response_to_struct(struct, freshness, response)
    else
      _ -> t2_cache_fallback(struct, accepted_freshness)
    end
  end

  defp t2_cache_fallback(struct, [:fresh]), do: metric_fallback_miss([:fresh], struct)

  defp t2_cache_fallback(struct, accepted_freshness) do
    case CCP.fetch(struct) do
      {:ok, :content_not_found} -> metric_fallback_miss(accepted_freshness, struct)
      {:ok, freshness, response} -> add_response_to_struct(struct, freshness, response)
    end
  end

  defp write_to_cache_stores(struct) do
    Local.store(struct)
    CCP.store(struct)

    :ok
  end

  defp metric_stale_response(:stale, _struct) do
    ExMetrics.increment("cache.stale_response_added_to_struct")
  end

  defp metric_stale_response(_freshness, _struct), do: :ok

  defp metric_fallback_miss(accepted_freshness, struct) do
    case Enum.member?(accepted_freshness, :stale) do
      true ->
        ExMetrics.increment("cache.fallback_item_does_not_exist")
        struct

      false ->
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

  defp is_get_request?(struct) do
    struct.request.method == "GET"
  end
end
