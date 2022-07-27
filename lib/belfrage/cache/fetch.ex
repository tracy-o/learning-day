defmodule Belfrage.Cache.Fetch do
  alias Belfrage.{Struct, Metrics.Statix, Event, Struct.Response}

  def fetch(struct, accepted_freshness, opts \\ []) do
    %{fallback: fallback} = Enum.into(opts, %{fallback: false})

    Belfrage.Cache.MultiStrategy.fetch(struct, accepted_freshness)
    |> case do
      {:ok, {:local, :fresh}, response} ->
        if fallback do
          Statix.increment("web.response.fallback", 1, tags: Event.global_dimensions())

          struct
          |> Struct.add(:private, %{
            origin: :belfrage_cache,
            personalised_route: response.personalised_route,
            personalised_request: false
          })
          |> Struct.add(:response, %Response{response | fallback: true})
        else
          struct
          |> Struct.add(:private, %{
            origin: :belfrage_cache,
            personalised_route: response.personalised_route,
            personalised_request: false
          })
          |> Struct.add(:response, response)
        end

      {:ok, {cache_type, :stale}, response} ->
        Statix.increment("web.response.fallback", 1, tags: Event.global_dimensions())
        Struct.add(struct, :response, %Response{response | fallback: true, cache_type: cache_type})

      {:ok, :content_not_found} ->
        struct
    end
  end
end
