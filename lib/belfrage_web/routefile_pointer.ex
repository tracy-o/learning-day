defmodule BelfrageWeb.RoutefilePointer do
  require Logger
  def init(_), do: :noop

  # We could use the conn.path_info[0] to split Routefiles  between news, sport, etc
  def call(conn, _opts) do
    cosmos_env = Application.get_env(:belfrage, :production_environment)
    mix_env = Mix.env()
    routefile = conn.assigns[:routefile] || routefile_module(conn, cosmos_env, mix_env)

    routefile.call(conn, routefile.init([]))
  end

  def routefile_module(conn, cosmos_env, mix_env) do
    Module.concat(["Routes", "Routefiles", product(conn), get_env(cosmos_env, mix_env)])
  end

  def get_env(_cosmos_env, :test), do: "Test"
  def get_env(_cosmos_env, :smoke_test), do: "Test"
  def get_env("live", _mix_env), do: "Live"
  def get_env("test", _mix_env), do: "Test"

  def get_env(cosmos_env, mix_env) do
    Logger.log(:error, "", %{
      msg: "Using Live Routefile as catch all",
      cosmos_env: cosmos_env,
      mix_env: mix_env
    })

    "Live"
  end

  defp product(_conn = %{path_info: []}), do: "Main"

  defp product(_conn = %{path_info: [product | _rest]}) do
    product = product |> String.split(".") |> List.first()

    case product do
      "sport" -> "Sport"
      _ -> "Main"
    end
  end
end
