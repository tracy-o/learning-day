defmodule Belfrage.Cache.Fetch do
  alias Belfrage.{Envelope, Envelope.Response}

  def fetch(envelope, accepted_freshness, opts \\ []) do
    %{fallback: fallback} = Enum.into(opts, %{fallback: false})

    Belfrage.Cache.MultiStrategy.fetch(envelope, accepted_freshness)
    |> case do
      {:ok, {:local, :fresh}, response} ->
        if fallback do
          :telemetry.execute([:belfrage, :web, :response, :fallback], %{count: 1})

          envelope
          |> Envelope.add(:private, %{
            origin: :belfrage_cache,
            personalised_route: response.personalised_route
          })
          |> Envelope.add(:response, %Response{response | fallback: true})
        else
          envelope
          |> Envelope.add(:private, %{
            origin: :belfrage_cache,
            personalised_route: response.personalised_route
          })
          |> Envelope.add(:response, response)
        end

      {:ok, {cache_type, :stale}, response} ->
        :telemetry.execute([:belfrage, :web, :response, :fallback], %{count: 1})
        Envelope.add(envelope, :response, %Response{response | fallback: true, cache_type: cache_type})

      {:ok, :content_not_found} ->
        envelope
    end
  end
end
