defmodule BelfrageWeb.LegacyRoutes do
  alias BelfrageWeb.{View, StructAdapter}

  @belfrage Application.get_env(:belfrage, :belfrage, Belfrage)

  import Plug.Conn

  def init(options), do: options

  @routes [
    {~r/mondo/, ["mondo"]},
    {~r/_legacy$/, ["legacy"]},
    {~r/_legacy\/page-type$/, ["legacy", "page_type"]},
    {~r/_legacy\/page-type\/123$/, ["legacy", "page_type_with_id"]}
  ]

  def call(%{} = conn, _opts) do
    with {_matcher, loop_id} <- find_loop_id(conn) do
      conn
      |> put_private(:loop_id, loop_id)
      |> StructAdapter.adapt()
      |> @belfrage.handle()
      |> View.render(conn)
    else
      nil -> View.not_found(conn)
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
