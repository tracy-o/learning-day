defmodule BelfrageWeb.RoutefilePointer do
  def init(_), do: :noop

  # TODO: we could use the conn.path_info[0] to split between news, sport, etc
  def call(conn, _opts) do
    cosmos_env = Application.get_env(:belfrage, :production_environment)
    mix_env = Mix.env()

    routefile = version(cosmos_env, mix_env)
    routefile = Module.concat(["Routes", "Routefiles", routefile])

    # TODO: Remove me! I'm here hust to help debugging :)
    IO.inspect routefile

    routefile.call(conn, routefile.init([]))
  end

  defp version("sandbox", _) do
    "Sandbox"
  end

  defp version(_, :test) do
    "Mock"
  end

  defp version(env, _) do
    env |> String.capitalize
  end
end
