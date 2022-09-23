defmodule EndToEnd.RssTest do
  use ExUnit.Case
  use Plug.Test
  alias BelfrageWeb.Router
  alias Belfrage.Clients.{HTTP, HTTPMock}
  use Test.Support.Helper, :mox

  setup do
    :ets.delete_all_objects(:cache)
    :ok
  end

  test "On 500 from FABL Response, body is changed to a Belfrage error " do
    fabl_endpoint = Application.get_env(:belfrage, :fabl_endpoint)

    url = "#{fabl_endpoint}/module/rss?guid=9f2b27b0-641f-4d9a-a400-b9db34e9cdea"

    expect(HTTPMock, :execute, 1, fn %HTTP.Request{url: ^url}, _pool ->
      {:ok,
       %HTTP.Response{
         headers: %{
           "cache-control" => "public, max-age=30"
         },
         status_code: 500,
         body: "500 Error from FABL"
       }}
    end)

    conn =
      conn(
        :get,
        "https://feeds.bbci.co.uk/sport/9f2b27b0-641f-4d9a-a400-b9db34e9cdea/rss.xml"
      )
      |> Router.call([])

    assert conn.resp_body == "<h1>500 Internal Server Error</h1>\n<!-- Belfrage -->"
    assert conn.status == 500
    assert get_resp_header(conn, "content-length") == []
  end

  test "On 404 from FABL Response, body is changed to a Belfrage error " do
    fabl_endpoint = Application.get_env(:belfrage, :fabl_endpoint)

    url = "#{fabl_endpoint}/module/rss?guid=9f2b27b0-641f-4d9a-a400-b9db34e9cdea"

    expect(HTTPMock, :execute, 1, fn %HTTP.Request{url: ^url}, _pool ->
      {:ok,
       %HTTP.Response{
         headers: %{
           "cache-control" => "public, max-age=30",
           "content-length" => "19"
         },
         status_code: 404,
         body: "404 Error from FABL"
       }}
    end)

    conn =
      conn(
        :get,
        "https://feeds.bbci.co.uk/sport/9f2b27b0-641f-4d9a-a400-b9db34e9cdea/rss.xml"
      )
      |> Router.call([])

    assert conn.resp_body == "<h1>404 Page Not Found</h1>\n<!-- Belfrage -->"
    assert conn.status == 404
    assert get_resp_header(conn, "content-length") == []
  end

  test "On successful response from FABL, response body is not changed " do
    fabl_endpoint = Application.get_env(:belfrage, :fabl_endpoint)

    url = "#{fabl_endpoint}/module/rss?guid=9f2b27b0-641f-4d9a-a400-b9db34e9cdea"

    expect(HTTPMock, :execute, 1, fn %HTTP.Request{url: ^url}, _pool ->
      {:ok,
       %HTTP.Response{
         headers: %{
           "cache-control" => "public, max-age=30"
         },
         status_code: 200,
         body: "RSS Content from FABL"
       }}
    end)

    conn =
      conn(
        :get,
        "https://feeds.bbci.co.uk/sport/9f2b27b0-641f-4d9a-a400-b9db34e9cdea/rss.xml"
      )
      |> Router.call([])

    assert conn.resp_body == "RSS Content from FABL"
    assert conn.status == 200
    assert get_resp_header(conn, "content-length") == []
  end
end
