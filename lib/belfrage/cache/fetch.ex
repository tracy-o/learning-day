defmodule Belfrage.Cache.Fetch do
  alias Belfrage.Struct

  def fetch(struct, accepted_freshness) do
    Belfrage.Cache.MultiStrategy.fetch(struct, accepted_freshness)
    |> case do
      {:ok, :fresh, response} ->
        Struct.add(struct, :response, response) |> Struct.add(:private, %{origin: :belfrage_cache})

      {:ok, :stale, response} ->
        Belfrage.Metrics.Statix.increment("web.response.fallback")
        Struct.add(struct, :response, response) |> Struct.add(:response, %{fallback: true})

      {:ok, :content_not_found} ->
        struct
    end
  end
end
