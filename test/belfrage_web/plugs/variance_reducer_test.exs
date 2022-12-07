defmodule BelfrageWeb.Plugs.VarianceReducerTest do
  use ExUnit.Case, async: true
  use Test.Support.Helper, :mox

  import Plug.Test, only: [conn: 2]

  alias BelfrageWeb.Plugs.VarianceReducer

  describe "with NewsAppsVarianceReduce Dial enabled" do
    test "removes the clientLoc query string on /fd/abl" do
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

    test "does NOT remove the clientLoc query string on other routes" do
      stub_dials(news_apps_variance_reducer: "enabled")
      path = "/fd/something/not/abl?clientName=Chrysalis&clientLoc=E7&type=index"

      conn =
        conn(:get, path)
        |> Plug.Conn.fetch_query_params(_opts = [])

      amended_conn = VarianceReducer.call(conn, [])

      assert "clientName=Chrysalis&clientLoc=E7&type=index" == amended_conn.query_string
      assert %{"clientName" => "Chrysalis", "type" => "index", "clientLoc" => "E7"} == amended_conn.query_params
      assert %{"clientName" => "Chrysalis", "type" => "index", "clientLoc" => "E7"} == amended_conn.params
    end
  end

  describe "with NewsAppsVarianceReduce Dial disabled" do
    test "does NOT remove the clientLoc query string on /fd/abl" do
      stub_dials(news_apps_variance_reducer: "disabled")
      path = "/fd/abl?clientName=Chrysalis&clientLoc=E7&type=index"

      conn =
        conn(:get, path)
        |> Plug.Conn.fetch_query_params(_opts = [])

      amended_conn = VarianceReducer.call(conn, [])

      assert "clientName=Chrysalis&clientLoc=E7&type=index" == amended_conn.query_string
      assert %{"clientName" => "Chrysalis", "type" => "index", "clientLoc" => "E7"} == amended_conn.query_params
      assert %{"clientName" => "Chrysalis", "type" => "index", "clientLoc" => "E7"} == amended_conn.params
    end

    test "does NOT remove the clientLoc query string on other routes" do
      stub_dials(news_apps_variance_reducer: "disabled")
      path = "/fd/something/not/abl?clientName=Chrysalis&clientLoc=E7&type=index"

      conn =
        conn(:get, path)
        |> Plug.Conn.fetch_query_params(_opts = [])

      amended_conn = VarianceReducer.call(conn, [])

      assert "clientName=Chrysalis&clientLoc=E7&type=index" == amended_conn.query_string
      assert %{"clientName" => "Chrysalis", "type" => "index", "clientLoc" => "E7"} == amended_conn.query_params
      assert %{"clientName" => "Chrysalis", "type" => "index", "clientLoc" => "E7"} == amended_conn.params
    end
  end
end
