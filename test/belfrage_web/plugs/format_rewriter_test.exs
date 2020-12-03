defmodule BelfrageWeb.Plugs.FormatRewriterTest do
  use ExUnit.Case
  use Plug.Test
  alias BelfrageWeb.Plugs.FormatRewriter

  describe "with a trailing format" do
    test "does not modify the request_path" do
      conn =
        conn(:get, "/foo/bar/123.json")
        |> FormatRewriter.call([])

      assert conn.request_path == "/foo/bar/123.json"
    end

    test "does modify the path_info to match `/foo/bar/:id/.json`" do
      conn =
        conn(:get, "/foo/bar/123.json")
        |> FormatRewriter.call([])

      assert conn.path_info == ["foo", "bar", "123", ".json"]
    end

    test "does modify the path_params" do
      conn =
        conn(:get, "/foo/bar/123.json")
        |> FormatRewriter.call([])

      assert conn.path_params == %{"format" => "json"}
    end
  end

  describe "with multiple formats" do
    test "does not modify the request_path" do
      conn =
        conn(:get, "/foo/bar/123.js.map")
        |> FormatRewriter.call([])

      assert conn.request_path == "/foo/bar/123.js.map"
    end

    test "does capture the trailing format and modify the path_info to match `/foo/bar/:id/.map`" do
      conn =
        conn(:get, "/foo/bar/123.456.js.map")
        |> FormatRewriter.call([])

      assert conn.path_info == ["foo", "bar", "123.456.js", ".map"]
    end

    test "does modify the path_params" do
      conn =
        conn(:get, "/foo/bar/123.js.map")
        |> FormatRewriter.call([])

      assert conn.path_params == %{"format" => "map"}
    end
  end

  describe "with no trailing format" do
    test "does not modify the request_path" do
      conn =
        conn(:get, "/foo/bar/123")
        |> FormatRewriter.call([])

      assert conn.request_path == "/foo/bar/123"
    end

    test "does not modify the path_info" do
      conn =
        conn(:get, "/foo/bar/123")
        |> FormatRewriter.call([])

      assert conn.path_info == ["foo", "bar", "123"]
    end

    test "does not modify the path_params" do
      conn =
        conn(:get, "/foo/bar/123")
        |> FormatRewriter.call([])

      assert conn.path_params == %{}
    end
  end

  describe "root path" do
    test "does not modify the request_path" do
      conn =
        conn(:get, "/")
        |> FormatRewriter.call([])

      assert conn.request_path == "/"
    end

    test "does not modify the path_info" do
      conn =
        conn(:get, "/")
        |> FormatRewriter.call([])

      assert conn.path_info == []
    end
  end
end
