defmodule Belfrage.Cache.Fetch do
  alias Belfrage.Struct

  def fetch(struct, [:fresh]), do: fetch_response(struct, [:fresh])
  def fetch(struct, [:fresh, :stale]), do: fetch_fallback(struct, [:fresh, :stale])
  def fetch(struct, _accepted_freshness), do: struct

  defp fetch_fallback(struct, accepted_freshness) do
    case allow_fallback?(struct) do
      true -> fetch_response(struct, accepted_freshness)
      false -> struct
    end
  end

  defp fetch_response(struct, accepted_freshness) do
    Belfrage.Cache.MultiStrategy.fetch(struct, accepted_freshness)
    |> case do
      {:ok, :fresh, response} ->
        Struct.add(struct, :response, response) |> Struct.add(:private, %{origin: :belfrage_cache})

      {:ok, :stale, response} ->
        Struct.add(struct, :response, response) |> Struct.add(:response, %{fallback: true})

      {:ok, :content_not_found} ->
        struct
    end
  end

  defp allow_fallback?(struct) do
    server_error?(struct) or request_timeout_error?(struct)
  end

  defp server_error?(struct) do
    struct.response.http_status >= 500
  end

  defp request_timeout_error?(struct) do
    struct.response.http_status == 408
  end
end
