defmodule BelfrageWeb.Plugs.InfiniteLoopGuardian do
  @moduledoc """
  Prevents infinite redirect loops between
  Belfrage and Mozart
  """

  def init(opts), do: opts

  def call(conn, _opts) do
    if loop_detected?(conn) do
      send_404(conn)
    else
      conn
    end
  end

  defp loop_detected?(conn) do
    case {bruce_stack?(), req_chain_count(conn)} do
      {true, count} when count > 1 -> true
      {false, count} when count > 0 -> true
      _ -> false
    end
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

  defp is_belfrage("BELFRAGE"), do: true
  defp is_belfrage(_service), do: false
end
