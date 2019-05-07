defmodule IngressWeb.ResponseHeaders.CacheControl do
  import Plug.Conn

  alias IngressWeb.Behaviours.ResponseHeaders

  @behaviour ResponseHeaders

  @impl ResponseHeaders
  def add_header(conn, struct) do
    put_resp_header(
      conn,
      "cache-control",
      "public, stale-while-revalidate=10, max-age=#{max_age(struct.response.http_status)}"
    )
  end

  defp max_age(status) when status in [404, 500], do: 5

  defp max_age(_response), do: 30
end
