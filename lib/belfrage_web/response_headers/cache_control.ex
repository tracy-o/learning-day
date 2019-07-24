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

  # TODO: implement no-cache for 500's if the requirements come up as per this discussion: https://github.com/bbc/belfrage/pull/41#discussion_r281946187
  defp cache_directive(struct) do
    %{cacheability: cacheability, max_age: max_age, stale_while_revalidate: stale_while_revalidate} =
      struct.response.cache_directive

    "#{cacheability}, stale-while-revalidate=#{stale_while_revalidate}, max-age=#{max_age}"
  end
end
