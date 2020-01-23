defmodule BelfrageWeb.Plugs.Overrides do
  @override_keys Belfrage.Overrides.keys()

  def init(opts), do: opts

  def call(conn = %Plug.Conn{private: %{production_environment: "live"}}, _opts) do
    Plug.Conn.put_private(conn, :overrides, %{})
  end

  def call(conn, _opts) do
    Plug.Conn.put_private(conn, :overrides, Map.take(conn.query_params, @override_keys))
  end
end
