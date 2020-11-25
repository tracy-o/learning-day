defmodule BelfrageWeb.Plugs.OverridesTest do
  use ExUnit.Case
  import Plug.Test, only: [conn: 2]

  test "does not add overrides on the live production environment" do
    conn =
      conn(:get, "/?belfrage-cache-bust")
      |> Plug.Conn.put_private(:production_environment, "live")
      |> Plug.Conn.fetch_query_params(_opts = [])

    assert %Plug.Conn{private: %{overrides: overrides}} = BelfrageWeb.Plugs.Overrides.call(conn, _opts = [])
    assert overrides == %{}
  end

  test "adds overrides when on a non-live environment" do
    conn =
      conn(:get, "/?belfrage-cache-bust")
      |> Plug.Conn.put_private(:production_environment, "test")
      |> Plug.Conn.fetch_query_params(_opts = [])

    assert %Plug.Conn{private: %{overrides: %{"belfrage-cache-bust" => nil}}} =
             BelfrageWeb.Plugs.Overrides.call(conn, _opts = [])
  end

  test "ignores non-override query string values" do
    conn =
      conn(:get, "/?not-an-override=true")
      |> Plug.Conn.put_private(:production_environment, "test")
      |> Plug.Conn.fetch_query_params(_opts = [])

    assert %Plug.Conn{private: %{overrides: %{}}} = BelfrageWeb.Plugs.Overrides.call(conn, _opts = [])
  end

  describe "ignores non-map query params" do
    test "on a test environment, when param is encoded" do
      conn =
        conn(:get, "/?%5D")
        |> Plug.Conn.put_private(:production_environment, "test")
        |> Plug.Conn.fetch_query_params(_opts = [])

      assert %Plug.Conn{private: %{overrides: %{}}} = BelfrageWeb.Plugs.Overrides.call(conn, _opts = [])
    end

    test "on a test environment, when param is not encoded" do
      conn =
        conn(:get, "/?]")
        |> Plug.Conn.put_private(:production_environment, "test")
        |> Plug.Conn.fetch_query_params(_opts = [])

      assert %Plug.Conn{private: %{overrides: %{}}} = BelfrageWeb.Plugs.Overrides.call(conn, _opts = [])
    end

    test "on a live environment, overrides are still ignored" do
      conn =
        conn(:get, "/?%5D")
        |> Plug.Conn.put_private(:production_environment, "live")
        |> Plug.Conn.fetch_query_params(_opts = [])

      assert %Plug.Conn{private: %{overrides: %{}}} = BelfrageWeb.Plugs.Overrides.call(conn, _opts = [])
    end
  end
end
