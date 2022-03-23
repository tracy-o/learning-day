defmodule BelfrageWeb.Plugs.InfiniteLoopGuardian do
  @moduledoc """
  Prevents infinite redirect loops between
  Belfrage and Mozart
  """

  def init(opts), do: opts

  def call(conn, _opts) do
    if loop_detected?(conn.request_path, req_chain_count(conn)) do
      send_404(conn)
    else
      conn
    end
  end

  defp loop_detected?(request_path, count) do
    if news_route?(request_path) and bruce_stack?(), do: count > 1, else: count > 0
  end

  defp bruce_stack?() do
    Application.get_env(:belfrage, :stack_id) == "bruce"
  end

  defp send_404(conn) do
    Belfrage.Event.record(:log, :error, %{
      msg: "Returned a 404 as infinite Belfrage/Mozart loop detected",
      request_path: conn.request_path
    })

    conn
    |> BelfrageWeb.Response.not_found()
    |> Plug.Conn.halt()
  end

  defp req_chain_count(conn) do
    Plug.Conn.get_req_header(conn, "req-svc-chain")
    |> to_string()
    |> String.split(",")
    |> Enum.count(&is_belfrage/1)
  end

  defp news_route?(request_path) do
    # is true for /news and /news/* request paths
    request_path == "/news" or String.starts_with?(request_path, "/news/")
  end

  defp is_belfrage("BELFRAGE"), do: true
  defp is_belfrage(_service), do: false
end
