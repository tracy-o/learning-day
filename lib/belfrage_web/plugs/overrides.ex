defmodule BelfrageWeb.Plugs.Overrides do
  @override_keys Belfrage.Overrides.keys()

  def init(opts), do: opts

  def call(conn = %Plug.Conn{private: %{production_environment: "live"}}, _opts) do
    Plug.Conn.put_private(conn, :overrides, %{})
  end

  def call(conn, _opts) do
    Plug.Conn.put_private(conn, :overrides, get_overrides(conn.query_params))
  end

  defp get_overrides(query_params) when is_map(query_params) do
    Map.take(query_params, @override_keys)
  end

  defp get_overrides(_query_params), do: %{}
end
