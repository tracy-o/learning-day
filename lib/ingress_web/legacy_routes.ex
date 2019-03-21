defmodule IngressWeb.LegacyRoutes do
  alias IngressWeb.{View, StructAdapter}

  use IngressWeb, :business_adapter

  def init(options), do: options

  @routes [
    {~r/mondo/, :mondo_loop_name}
  ]

  def call(%{} = conn, _opts) do
    with {_matcher, loop_name} <- find_loop_name(conn) do
      StructAdapter.adapt(loop_name, conn)
      |> ingress().handle()
      |> View.render(conn)
    else
      nil -> View.render(conn, 404)
    end
  end

  defp find_loop_name(conn) do
    @routes
    |> Enum.find(fn route -> match_route?(conn, route) end)
  end

  def match_route?(%{request_path: request_path}, {regex_matcher, _loop_name}) do
    String.match?(request_path, regex_matcher)
  end
end
