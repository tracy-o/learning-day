defmodule Belfrage.Fallback do
  alias Belfrage.Struct
  alias Belfrage.Cache

  def fallback_if_required(struct = %Struct{}) do
    case server_error?(struct) or request_timeout_error?(struct) do
      true -> Cache.get(struct, [:fresh, :stale])
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
