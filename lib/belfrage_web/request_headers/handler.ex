defmodule BelfrageWeb.RequestHeaders.Handler do
  import Plug.Conn

  @moduledoc """
  """

  alias BelfrageWeb.RequestHeaders.Sanitiser
  alias BelfrageWeb.RequestHeaders.Mapper
  alias Belfrage.Metrics

  def init(opts), do: opts

  def call(conn, _opts) do
    Metrics.duration(:process_request_headers, fn ->
      put_private(conn, :bbc_headers, bbc_headers(Mapper.map(conn.req_headers)))
    end)
  end

  defp bbc_headers(req_headers) do
    cache = Sanitiser.cache(req_headers[:cache], nil)
    Enum.into(req_headers, %{}, fn {k, v} -> {k, apply(Sanitiser, k, [v, cache])} end)
  end
end
