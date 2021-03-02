defmodule BelfrageWeb.Plugs.InfiniteLoopGuardian do
  @moduledoc """
  Prevents infinite redirect loops between
  Belfrage and Mozart
  """

  def init(opts), do: opts

  def call(conn, _opts) do
    Plug.Conn.get_req_header(conn, "req-svc-chain")
    |> to_string()
    |> String.contains?("BELFRAGE")
    |> case do
      true -> send_404(conn)
      false -> conn
    end
  end

  defp send_404(conn) do
    conn
    |> BelfrageWeb.View.not_found()
    |> Plug.Conn.halt()
  end
end
