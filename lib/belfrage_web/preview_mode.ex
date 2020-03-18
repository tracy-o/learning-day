defmodule BelfrageWeb.PreviewMode do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    put_private(
      conn,
      :preview_mode,
      Application.get_env(:belfrage, :preview_mode)
    )
  end
end
