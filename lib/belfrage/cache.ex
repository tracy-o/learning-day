defmodule Belfrage.Cache do
  alias Belfrage.Struct
  alias Belfrage.Cache.Local

  def store_if_successful(struct) do
    if is_cacheable?(struct), do: Local.store(struct)

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
      _ -> metric_fallback_miss(accepted_freshness, struct)
    end
  end

  defp metric_stale_response(:stale, struct) do
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

      _ ->
        Struct.add(struct, :response, response)
    end
  end

  defp is_cacheable?(struct) do
    is_successful_response?(struct) and is_get_request?(struct) and
      Belfrage.Cache.CacheControlParser.parse(struct.response) > 0
  end

  defp is_successful_response?(struct) do
    struct.response.http_status == 200
  end

  defp is_get_request?(struct) do
    struct.request.method == "GET"
  end
end
