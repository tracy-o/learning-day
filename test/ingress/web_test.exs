defmodule Ingress.WebTest do
  use ExUnit.Case
  use Plug.Test

  alias Ingress.Web

  import Mock

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
      with_mock InvokeLambda, [invoke: fn(_function_name, _options) -> {200, %{"body" => "hello homepage"}} end] do
        conn = conn(:get, "/")
        conn = Web.call(conn, [])

        assert conn.state == :sent
        assert conn.status == 200
        assert get_resp_header(conn, "content-type") == ["text/html; charset=utf-8"]
        assert conn.resp_body == "hello homepage"

        assert_called(
          InvokeLambda.invoke("presentation-layer",%{function_payload: %{path: "/"}, role: "presentation-role"})
        )
      end
    end
  end

  describe "HEAD /" do
    test "will return a welcome message" do
      with_mock InvokeLambda, [invoke: fn(_function_name, _options) -> {200, %{"body" => "hello homepage"}} end] do
        conn = conn(:head, "/")
        conn = Web.call(conn, [])

        assert conn.state == :sent
        assert conn.status == 200
        assert get_resp_header(conn, "content-type") == ["text/html; charset=utf-8"]
        assert conn.resp_body == ""

        assert_called(
          InvokeLambda.invoke("presentation-layer",%{function_payload: %{path: "/"}, role: "presentation-role"})
        )
      end
    end
  end

  describe "GET /:service" do
    for path <- ["/news", "/sport", "/weather", "/bitesize", "/cbeebies", "/dynasties"] do
      @path path

      test "#{@path} will return a 200" do
        service = String.replace(@path, "/", "")

        with_mock InvokeLambda, [invoke: fn(_function_name, _options) -> {200, %{"body" => "hello #{service}"}} end] do
          conn = conn(:get, @path)
          conn = Web.call(conn, [])

          assert conn.status == 200
          assert get_resp_header(conn, "content-type") == ["text/html; charset=utf-8"]

          assert conn.resp_body == "hello #{service}"

          assert_called(
            InvokeLambda.invoke("presentation-layer",%{function_payload: %{path: @path}, role: "presentation-role"})
          )
        end
      end
    end
  end

  describe "POST /graphql" do
    @request_payload "{\"my\":\"request\"}"
    @response_payload "{\"my\":\"response\"}"

    test "will return a 200" do
      with_mock InvokeLambda, [invoke: fn(_function_name, _options) -> {200, %{"body" => @response_payload}} end] do
        conn = conn(:post, "/graphql", @request_payload)
        conn = Web.call(conn, [])

        assert conn.status == 200
        assert get_resp_header(conn, "content-type") == ["application/json; charset=utf-8"]

        assert conn.resp_body == @response_payload

        assert_called(
          InvokeLambda.invoke(
            "business-layer",
            %{function_payload: %{body: @request_payload, httpMethod: "POST"}, role: "business-role"}
          )
        )
      end
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
