defmodule Ingress.WebTest do
  use ExUnit.Case
  use Plug.Test

  alias Ingress.Web
  #@opts Ingress.init([])

  describe "GET /status" do
    test "will return 'OK'" do
      conn = conn(:get, "/status")
      conn = Web.call(conn, [])

      assert conn.state == :sent
      assert conn.status == 200
      assert get_resp_header(conn, "content-type") == ["text/plain; charset=utf-8"]
      assert conn.resp_body == "ok!"
    end
  end

  describe "GET /" do
    test "will return a welcome message" do
      conn = conn(:get, "/")
      conn = Web.call(conn, [])

      assert conn.state == :sent
      assert conn.status == 200
      assert get_resp_header(conn, "content-type") == ["text/html; charset=utf-8"]
      assert conn.resp_body == "hello homepage"
    end
  end

  describe "HEAD /" do
    test "will return a welcome message" do
      conn = conn(:head, "/")
      conn = Web.call(conn, [])

      assert conn.state == :sent
      assert conn.status == 200
      assert get_resp_header(conn, "content-type") == ["text/html; charset=utf-8"]
      assert conn.resp_body == ""
    end
  end

  describe "GET /:service" do
    for path <- ["/news", "/sport", "/weather", "/bitesize", "/cbeebies", "/dynasties"] do
      @path path

      test "#{@path} will return a 200" do
        conn = conn(:get, @path)
        conn = Web.call(conn, [])

        assert conn.status == 200
        assert get_resp_header(conn, "content-type") == ["text/html; charset=utf-8"]

        service = String.replace(@path, "/", "")
        assert conn.resp_body == "hello #{service}"
      end
    end
  end

  describe "POST /graphql" do
    test "will return a 200" do
      conn = conn(:post, "/graphql", "{\"a\":1}")
      conn = Web.call(conn, [])

      assert conn.status == 200
      assert get_resp_header(conn, "content-type") == ["application/json; charset=utf-8"]

      assert conn.resp_body == "{\"data\":[]}"
    end
  end

  describe "Page not found" do
    test "will return a 'Not Found' message" do
      conn = conn(:get, "/foobar")
      conn = Web.call(conn, [])

      assert conn.state == :sent
      assert conn.status == 404
      assert get_resp_header(conn, "content-type") == ["text/html; charset=utf-8"]
      assert conn.resp_body == "Not Found"
    end
  end
end
