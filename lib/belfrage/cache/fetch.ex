defmodule Belfrage.Cache.Fetch do
  alias Belfrage.Struct

  def fetch_fallback_on_error(struct) do
    case allow_fallback?(struct) do
      true -> fetch(struct, [:fresh, :stale])
      false -> struct
    end
  end

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

  defp allow_fallback?(struct) do
    server_error?(struct) or valid_fallback_4xx_status?(struct)
  end

  defp valid_fallback_4xx_status?(struct) do
    Enum.member?([401, 403, 408], struct.response.http_status)
  end

  defp server_error?(struct) do
    struct.response.http_status >= 500
  end
end
