defmodule BelfrageWeb.Plug.OverridesTest do
  use ExUnit.Case
  import Plug.Test, only: [conn: 2]

  test "does not add overrides on the live production environment" do
    conn =
      conn(:get, "/?belfrage-cache-bust")
      |> Plug.Conn.put_private(:production_environment, "live")
      |> Plug.Conn.fetch_query_params(_opts = [])

    assert %Plug.Conn{private: %{overrides: overrides}} = BelfrageWeb.Plug.Overrides.call(conn, _opts = [])
    assert overrides == %{}
  end

  test "adds overrides when on a non-live environment" do
    conn =
      conn(:get, "/?belfrage-cache-bust")
      |> Plug.Conn.put_private(:production_environment, "test")
      |> Plug.Conn.fetch_query_params(_opts = [])

    assert %Plug.Conn{private: %{overrides: %{"belfrage-cache-bust" => nil}}} =
             BelfrageWeb.Plug.Overrides.call(conn, _opts = [])
  end

  test "ignores non-override query string values" do
    conn =
      conn(:get, "/?not-an-override=true")
      |> Plug.Conn.put_private(:production_environment, "test")
      |> Plug.Conn.fetch_query_params(_opts = [])

    assert %Plug.Conn{private: %{overrides: %{}}} = BelfrageWeb.Plug.Overrides.call(conn, _opts = [])
  end
end
