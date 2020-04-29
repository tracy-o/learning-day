defmodule Belfrage.Cache.Fetch do
  alias Belfrage.Struct

  def fetch(struct, accepted_freshness) do
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

end
