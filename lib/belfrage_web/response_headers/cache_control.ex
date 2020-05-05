defmodule BelfrageWeb.ResponseHeaders.CacheControl do
  import Plug.Conn

  alias BelfrageWeb.Behaviours.ResponseHeaders

  @behaviour ResponseHeaders

  @impl ResponseHeaders
  def add_header(conn, struct) do
    put_resp_header(
      conn,
      "cache-control",
      cache_directive(struct)
    )
  end

  defp cache_directive(struct) do
    %Belfrage.CacheControl{cacheability: cacheability, max_age: max_age, stale_while_revalidate: stale_while_revalidate} =
      struct.response.cache_directive

    cacheability <> key("stale-while-revalidate", stale_while_revalidate) <> key("max-age", max_age)
  end

  defp key(_key_name, nil), do: ""
  defp key(key_name, value), do: ", #{key_name}=#{value}"
end
