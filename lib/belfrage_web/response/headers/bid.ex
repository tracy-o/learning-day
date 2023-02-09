defmodule BelfrageWeb.Response.Headers.BID do
  import Plug.Conn

  @behaviour BelfrageWeb.Response.Headers.Behaviour

  @impl true
  def add_header(conn, _envelope) do
    put_resp_header(conn, "bid", bid_value())
  end

  defp bid_value do
    Application.get_env(:belfrage, :stack_id)
  end
end
