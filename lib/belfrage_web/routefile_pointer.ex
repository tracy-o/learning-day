defmodule BelfrageWeb.RoutefilePointer do
  def init(_), do: :noop

  # We could use the conn.path_info[0] to split Routefiles  between news, sport, etc
  def call(conn, _opts) do
    cosmos_env = Application.get_env(:belfrage, :production_environment)
    mix_env = Mix.env()
    routefile = routefile(cosmos_env, mix_env)

    routefile.call(conn, routefile.init([]))
  end

  def routefile(_cosmos_env, _mix_env = :dev) do
    Routes.Routefiles.Test
  end

  def routefile(_cosmos_env, _mix_env = :test) do
    Routes.Routefiles.Mock
  end

  def routefile(_cosmos_env, _mix_env = :routes_test) do
    Routes.Routefiles.Test
  end

  def routefile(_cosmos_env, _mix_env = :end_to_end) do
    Routes.Routefiles.Mock
  end

  def routefile(_cosmos_env, _mix_env = :smoke_test) do
    Routes.Routefiles.Test
  end

  def routefile("test", _mix_env) do
    Routes.Routefiles.Test
  end

  def routefile("live", _mix_env) do
    Routes.Routefiles.Live
  end

  def routefile(cosmos_env, mix_env) do
    Belfrage.Event.record(:log, :error, %{
      msg: "Using Live Routefile as catch all",
      cosmos_env: cosmos_env,
      mix_env: mix_env
    })

    Routes.Routefiles.Live
  end
end
