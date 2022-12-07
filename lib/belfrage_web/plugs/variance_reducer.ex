defmodule BelfrageWeb.Plugs.VarianceReducer do
  @moduledoc """
  """

  @dial Application.get_env(:belfrage, :dial)

  def init(opts), do: opts

  def call(conn = %{request_path: "/fd/abl", query_params: query_params = %{"clientLoc" => _val}}, _opts) do
    if news_apps_variance_reducer_dial_enabled?() do
      conn
      |> Map.merge(%{
            query_params: Map.reject(
              query_params,
              fn {key, _val} -> key == "clientLoc" end)})
    else
      conn
    end
  end

  def call(conn, _opts) do
    conn
  end

  defp news_apps_variance_reducer_dial_enabled? do
    @dial.state(:news_apps_variance_reducer) == "enabled"
  end
end
