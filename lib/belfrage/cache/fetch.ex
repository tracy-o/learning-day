defmodule Belfrage.Cache.Fetch do
  alias Belfrage.{Struct, Metrics.Statix, Event}

  def fetch(struct, accepted_freshness) do
    Belfrage.Cache.MultiStrategy.fetch(struct, accepted_freshness)
    |> case do
      {:ok, {:local, :fresh}, response} ->
        Struct.add(struct, :response, response) |> Struct.add(:private, %{origin: :belfrage_cache})

      {:ok, {cache_type, :stale}, response} ->
        Belfrage.Metrics.Statix.increment("web.response.fallback", 1, tags: Event.global_dimensions())
        Struct.add(struct, :response, response) |> Struct.add(:response, %{fallback: true, cache_type: cache_type})

      {:ok, :content_not_found} ->
        struct
    end
  end
end
