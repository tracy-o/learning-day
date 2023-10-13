defmodule EndToEnd.NotModifiedResponseTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox

  alias BelfrageWeb.Router
  alias Belfrage.{Clients.HTTPMock, Clients.HTTP}

  describe "304 responses" do
    setup do
      {:ok,
       response_stub: %HTTP.Response{
         status_code: 304,
         body: "",
         headers: %{"some-header" => "some-value"}
       }}
    end

    test "have only headers added", %{response_stub: response_stub} do
      expect(HTTPMock, :execute, 1, fn _request, _origin ->
        {:ok, response_stub}
      end)

      conn =
        conn(:get, "http://news-app-classic.test.api.bbci.co.uk/classic-apps-route")
        |> Router.call(routefile: Routes.Routefiles.Mock)

      assert {status_code, headers, body} = sent_resp(conn)

      assert body == response_stub.body

      assert status_code == response_stub.status_code

      assert added_header_keys(headers, response_stub.headers) == [
               "belfrage-cache-status",
               "belfrage-preflight-pipeline-trail",
               "belfrage-request-pipeline-trail",
               "belfrage-response-pipeline-trail",
               "bid",
               "brequestid",
               "bsig",
               "cache-control",
               "etag",
               "req-svc-chain",
               "routespec",
               "server",
               "vary",
               "via"
             ]
    end

    test "are not cached", %{response_stub: response_stub} do
      expect(HTTPMock, :execute, 2, fn _request, _origin ->
        {:ok, response_stub}
      end)

      conn =
        conn(:get, "http://news-app-classic.test.api.bbci.co.uk/classic-apps-route")
        |> Router.call(routefile: Routes.Routefiles.Mock)

      assert ["MISS"] == get_resp_header(conn, "belfrage-cache-status")

      conn =
        conn(:get, "http://news-app-classic.test.api.bbci.co.uk/classic-apps-route")
        |> Router.call(routefile: Routes.Routefiles.Mock)

      assert ["MISS"] == get_resp_header(conn, "belfrage-cache-status")
    end
  end

  defp added_header_keys(h1, h2) do
    MapSet.difference(MapSet.new(header_keys(h1)), MapSet.new(header_keys(h2)))
    |> MapSet.to_list()
  end

  defp header_keys(headers) do
    Enum.map(headers, &Kernel.elem(&1, 0))
  end
end
