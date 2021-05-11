defmodule BelfrageWeb.RoutefilePointer do
  def init(_), do: :noop

  # TODO: we could use the conn.path_info[0] to split between news, sport, etc
  def call(conn, _opts) do
    cosmos_env = Application.get_env(:belfrage, :production_environment)
    mix_env = Mix.env()

    routefile = routefile(cosmos_env, mix_env)

    # TODO: Remove me! I'm here hust to help debugging :)
    IO.inspect(routefile)

    routefile.call(conn, routefile.init([]))
  end

  def routefile(_cosmos_env, :dev = _mix_env) do
    "Sandbox" |> routefile_module()
  end

  def routefile(_cosmos_env, :test = _mix_env) do
    "Mock" |> routefile_module()
  end

  def routefile(_cosmos_env, :routes_test = _mix_env) do
    "Test" |> routefile_module()
  end

  def routefile(cosmos_env, _mix_env) when cosmos_env in ["live", "test"] do
    cosmos_env
    |> String.capitalize()
    |> routefile_module()
  end

  def routefile(cosmos_env, _mix_env) do
    "Live" |> routefile_module()
  end

  defp routefile_module(name) do
    Module.concat(["Routes", "Routefiles", name])
  end
end
