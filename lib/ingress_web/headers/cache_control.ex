defmodule IngressWeb.Headers.CacheControl do
  import Plug.Conn

  alias IngressWeb.Behaviours.Headers

  @behaviour Headers

  @impl Headers
  def add_header(conn, struct) do
    put_resp_header(
      conn,
      "cache-control",
      "public, stale-while-revalidate=10, max-age=#{max_age(struct.response)}"
    )
  end

  defp max_age(%Ingress.Struct.Response{http_status: 404}), do: 5

  defp max_age(_resposne), do: 30
end
