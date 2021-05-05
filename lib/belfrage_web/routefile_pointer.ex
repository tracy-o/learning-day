defmodule BelfrageWeb.RoutefilePointer do
  def init(_), do: :noop

  def call(conn, _opts) do
    # IO.inspect conn.path_info

    routefile = Application.get_env(:belfrage, :production_environment) |> version()
    routefile = Module.concat(["Routes", "Routefiles", routefile])

    IO.inspect routefile

    routefile.call(conn, routefile.init([]))
  end

  defp version("dev") do
    "Sandbox"
  end

  defp version(env) do
    env |> String.capitalize
  end
end
