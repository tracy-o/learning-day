defmodule BelfrageWeb.Plugs.InfiniteLoopGuardian do
  @moduledoc """
  Prevents infinite redirect loops between
  Belfrage and Mozart
  """

  def init(opts), do: opts

  def call(conn, _opts) do
    Plug.Conn.get_req_header(conn, "req-svc-chain")
    |> to_string()
    |> String.split(",")
    |> Enum.count(&is_belfrage/1)
    |> case do
      count when count > 2 -> send_404(conn)
      _ -> conn
    end
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

  def is_belfrage("BELFRAGE"), do: true
  def is_belfrage(_service), do: false
end
