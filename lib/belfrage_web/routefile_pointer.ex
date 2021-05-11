defmodule BelfrageWeb.RoutefilePointer do
  def init(_), do: :noop

  # We could use the conn.path_info[0] to split between news, sport, etc
  def call(conn, _opts) do
    cosmos_env = Application.get_env(:belfrage, :production_environment)
    mix_env = Mix.env()
    routefile = routefile(cosmos_env, mix_env)

    routefile.call(conn, routefile.init([]))
  end

  def routefile(_cosmos_env, _mix_env = :dev) do
    "Sandbox" |> routefile_module()
  end

  def routefile(_cosmos_env, _mix_env = :test) do
    "Mock" |> routefile_module()
  end

  def routefile(_cosmos_env, _mix_env = :routes_test) do
    "Test" |> routefile_module()
  end

  def routefile(_cosmos_env, _mix_env = :end_to_end) do
    "Mock" |> routefile_module()
  end

  def routefile(_cosmos_env, _mix_env = :smoke_test) do
    "Test" |> routefile_module()
  end

  def routefile(cosmos_env, _mix_env) when cosmos_env in ["live", "test"] do
    cosmos_env
    |> String.capitalize()
    |> routefile_module()
  end

  def routefile(_cosmos_env, _mix_env) do
    "Live" |> routefile_module()
  end

  defp routefile_module(name) do
    Module.concat(["Routes", "Routefiles", name])
  end
end
