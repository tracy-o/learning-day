defmodule Belfrage.Cache do
  alias Belfrage.Struct

  defdelegate store(struct), to: Belfrage.Cache.Store

  defdelegate fetch(struct, accepted_freshness), to: Belfrage.Cache.Fetch

  def fetch_fallback(struct = %Struct{}) do
    case server_error?(struct) or request_timeout_error?(struct) do
      true -> fetch(struct, [:fresh, :stale])
      false -> struct
    end
  end

  defp server_error?(struct) do
    struct.response.http_status >= 500
  end

  defp request_timeout_error?(struct) do
    struct.response.http_status == 408
  end
end
