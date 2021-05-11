defmodule BelfrageWeb.RoutefilePointer do
  def init(_), do: :noop

  # TODO: we could use the conn.path_info[0] to split between news, sport, etc
  def call(conn, _opts) do
    cosmos_env = Application.get_env(:belfrage, :production_environment)
    mix_env = Mix.env()

    routefile = version(cosmos_env, mix_env)
    routefile = Module.concat(["Routes", "Routefiles", routefile])

    # TODO: Remove me! I'm here hust to help debugging :)
    IO.inspect(routefile)

    routefile.call(conn, routefile.init([]))
  end

  defp version("sandbox" = _cosmos_env, _mix_env) do
    "Sandbox"
  end

  defp version(_cosmos_env, :test = _mix_env) do
    "Mock"
  end

  defp version(_cosmos_env, :routes_test = _mix_env) do
    "Test"
  end

  defp version(cosmos_env, _mix_env) do
    cosmos_env |> String.capitalize()
  end
end
