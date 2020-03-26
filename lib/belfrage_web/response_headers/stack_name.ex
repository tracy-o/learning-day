defmodule BelfrageWeb.ResponseHeaders.StackName do
  import Plug.Conn

  alias BelfrageWeb.Behaviours.ResponseHeaders

  @behaviour ResponseHeaders

  @impl ResponseHeaders
  def add_header(conn, _struct) do
    put_resp_header(conn, "bid", stack_name())
  end

  defp stack_name do
    Application.get_env(:belfrage, :stack_name)
  end
end
