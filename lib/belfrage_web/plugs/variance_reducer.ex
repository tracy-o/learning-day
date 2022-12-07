defmodule BelfrageWeb.Plugs.VarianceReducer do
  @moduledoc """
  Allow lowering pressure on origins by reducing the cache variation.
  When the NewsAppVarianceReducer dial is enabled and the path matches, specific query strings
  get removed from the conn.

  This feature is currently used exclusively by News Apps but could be extended to other products.
  """

  @dial Application.get_env(:belfrage, :dial)

  def init(opts), do: opts

  def call(conn = %{request_path: "/fd/abl"}, _opts) do
    if reducible_query_string?(conn) and news_apps_variance_reducer_dial_enabled?() do
      conn =
        conn
        |> Map.merge(%{
          query_params:
            Map.reject(
              conn.query_params,
              fn {key, _val} -> key == "clientLoc" end
            )
        })
        |> Map.merge(%{
          params:
            Map.reject(
              conn.params,
              fn {key, _val} -> key == "clientLoc" end
            )
        })

      # This does not guarantee that the order of the original query string would be mantained
      conn |> Map.merge(%{query_string: conn.query_params |> URI.encode_query()})
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

  defp reducible_query_string?(conn) do
    conn.query_string |> String.contains?("clientLoc")
  end
end
