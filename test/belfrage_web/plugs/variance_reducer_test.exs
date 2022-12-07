defmodule BelfrageWeb.Plugs.VarianceReducerTest do
  use ExUnit.Case, async: true
  use Test.Support.Helper, :mox

  import Plug.Test, only: [conn: 2]

  alias BelfrageWeb.Plugs.VarianceReducer

  describe "with NewsAppsVarianceReduce Dial enabled" do
    test "remove teh query string" do
      stub_dials(news_apps_variance_reducer: "enabled")

      path = "/fd/abl?clientName=Chrysalis&clientLoc=E7&type=index"

      conn =
        conn(:get, path)
        |> Plug.Conn.fetch_query_params(_opts = [])

      amended_conn = VarianceReducer.call(conn, [])

      assert "clientName=Chrysalis&type=index" == amended_conn.query_string
      assert %{"clientName" => "Chrysalis", "type" => "index"} == amended_conn.query_params
      assert %{"clientName" => "Chrysalis", "type" => "index"} == amended_conn.params
    end
  end
end
