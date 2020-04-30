defmodule Belfrage.Cache.Fetch do
  alias Belfrage.Struct

  def fetch(struct, accepted_freshness) do
    case :stale in accepted_freshness do
      true -> fetch_fallback(struct, accepted_freshness)
      false -> fetch_response(struct, accepted_freshness)
    end
  end

  defp fetch_fallback(struct, accepted_freshness) do
    case allow_fallback?(struct) do
      true -> fetch_response(struct, accepted_freshness)
      false -> struct
    end
  end

  defp fetch_response(struct, accepted_freshness) do
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
