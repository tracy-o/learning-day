defmodule Belfrage.Cache.Fetch do
  alias Belfrage.Struct

  def fetch(struct, accepted_freshness) do
    case :stale in accepted_freshness do
      true -> fetch_fallback(struct, accepted_freshness)
      false -> add_response_to_struct(struct, accepted_freshness)
    end
  end

  defp fetch_fallback(struct, accepted_freshness) do
    case allow_fallback?(struct) do
      true -> add_response_to_struct(struct, accepted_freshness)
      false -> struct
    end
  end

  defp add_response_to_struct(struct, accepted_freshness) do
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
