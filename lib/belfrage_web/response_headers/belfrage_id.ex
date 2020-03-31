defmodule BelfrageWeb.ResponseHeaders.BelfrageID do
  import Plug.Conn

  alias BelfrageWeb.Behaviours.ResponseHeaders

  @behaviour ResponseHeaders

  @impl ResponseHeaders
  def add_header(conn, _struct) do
    put_resp_header(conn, "bid", bid_value())
  end

  defp bid_value do
    Application.get_env(:belfrage, :stack_id)
  end
end
