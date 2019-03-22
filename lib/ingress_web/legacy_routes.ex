defmodule IngressWeb.LegacyRoutes do
  alias IngressWeb.{View, StructAdapter}

  @ingress Application.get_env(:ingress, :ingress, Ingress)

  import Plug.Conn

  def init(options), do: options

  @routes [
    {~r/mondo/, ["mondo"]},
    {~r/_legacy/, ["legacy"]}
  ]

  def call(%{} = conn, _opts) do
    with {_matcher, loop_id} <- find_loop_id(conn) do
      conn
      |> put_private(:loop_id, loop_id)
      |> StructAdapter.adapt()
      |> @ingress.handle()
      |> View.render(conn)
    else
      nil -> View.render(conn, 404)
    end
  end

  defp find_loop_id(conn) do
    @routes
    |> Enum.find(fn route -> match_route?(conn, route) end)
  end

  def match_route?(%{request_path: request_path}, {regex_matcher, _loop_id}) do
    String.match?(request_path, regex_matcher)
  end
end
