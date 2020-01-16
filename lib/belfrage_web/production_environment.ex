defmodule BelfrageWeb.ProductionEnvironment do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    put_private(
      conn,
      :production_environment,
      Application.get_env(:belfrage, :production_environment)
    )
  end
end
