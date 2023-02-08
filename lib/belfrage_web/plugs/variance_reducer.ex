defmodule BelfrageWeb.Plugs.VarianceReducer do
  @moduledoc """
  Allow lowering pressure on origins by reducing the cache variation.
  When the NewsAppVarianceReducer dial is enabled and the path matches, specific query strings
  get removed from the conn.

  This feature is currently used exclusively by News Apps but could be extended to other products.
  """

  @dial Application.compile_env(:belfrage, :dial)

  def init(opts), do: opts

  def call(conn = %{request_path: "/fd/abl"}, _opts) do
    if news_apps_variance_reducer_dial_enabled?() do
      upd_query_params = remove_query_param("clientLoc", conn.query_params)
      upd_params = remove_query_param("clientLoc", conn.params)

      %{
        conn
        | query_params: upd_query_params,
          params: upd_params,
          query_string: URI.encode_query(upd_query_params)
      }
    else
      conn
    end
  end

  def call(conn, _opts) do
    conn
  end

  defp remove_query_param(param, map) do
    Map.reject(map, fn {key, _} -> key == param end)
  end

  defp news_apps_variance_reducer_dial_enabled? do
    @dial.state(:news_apps_variance_reducer) == "enabled"
  end
end
