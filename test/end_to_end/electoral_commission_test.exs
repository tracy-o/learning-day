defmodule EndToEnd.ElectoralCommissionTest do
  use ExUnit.Case
  use Plug.Test
  alias BelfrageWeb.Router
  alias Belfrage.Clients.{HTTP, HTTPMock}
  use Test.Support.Helper, :mox

  describe "request is made to Electoral Commission" do
    setup do
      :ets.delete_all_objects(:cache)
      :ok
    end

    test "successful response returns a 200 for election postcode" do
      ec_endpoint = Application.get_env(:belfrage, :electoral_commission_endpoint)

      url = "#{ec_endpoint}/api/v1/postcode/IP224DN/?token=f110d812b94d8cdf517765ff8657b89e8b08ebd6"

      expect(HTTPMock, :execute, 1, fn %HTTP.Request{url: ^url}, _pool ->
        {:ok,
         %HTTP.Response{
           headers: %{
             "cache-control" => "private",
             "vary" => "something",
             "content-type" => "application/json"
           },
           status_code: 200,
           body: "{}"
         }}
      end)

      conn =
        conn(
          :get,
          "https://web-cdn.test.api.bbci.co.uk/election2023postcode/IP224DN"
        )
        |> put_req_header("x-bbc-edge-cdn", "1")
        |> Router.call([])

      assert conn.status == 200

      assert ["public, stale-if-error=90, stale-while-revalidate=30, max-age=5"] =
               get_resp_header(conn, "cache-control")

      assert ["Accept-Encoding"] = get_resp_header(conn, "vary")
      assert ["application/json"] = get_resp_header(conn, "content-type")
    end

    test "successful response returns a 200 for electoral uprn" do
      ec_endpoint = Application.get_env(:belfrage, :electoral_commission_endpoint)

      url = "#{ec_endpoint}/api/v1/address/25050756/?token=f110d812b94d8cdf517765ff8657b89e8b08ebd6"

      expect(HTTPMock, :execute, 1, fn %HTTP.Request{url: ^url}, _pool ->
        {:ok,
         %HTTP.Response{
           headers: %{
             "cache-control" => "private",
             "vary" => "something",
             "content-type" => "application/json"
           },
           status_code: 200,
           body: "{}"
         }}
      end)

      conn =
        conn(
          :get,
          "https://web-cdn.test.api.bbci.co.uk/election2023address/25050756"
        )
        |> put_req_header("x-bbc-edge-cdn", "1")
        |> Router.call([])

      assert conn.status == 200

      assert ["public, stale-if-error=90, stale-while-revalidate=30, max-age=5"] =
               get_resp_header(conn, "cache-control")

      assert ["Accept-Encoding"] = get_resp_header(conn, "vary")
      assert ["application/json"] = get_resp_header(conn, "content-type")
    end

    test "returns 404 on invalid postcodes" do
      conn =
        conn(
          :get,
          "https://web-cdn.test.api.bbci.co.uk/election2023postcode/foo456"
        )
        |> put_req_header("x-bbc-edge-cdn", "1")
        |> Router.call([])

      assert conn.status == 404

      assert ["public, stale-if-error=90, stale-while-revalidate=60, max-age=30"] =
               get_resp_header(conn, "cache-control")

      assert ["Accept-Encoding"] = get_resp_header(conn, "vary")
      assert ["text/html; charset=utf-8"] = get_resp_header(conn, "content-type")
    end

    test "returns 401 on invalid token" do
      ec_endpoint = Application.get_env(:belfrage, :electoral_commission_endpoint)

      # assuming an invalid token
      url = "#{ec_endpoint}/api/v1/address/25050756/?token=f110d812b94d8cdf517765ff8657b89e8b08ebd6"

      expect(HTTPMock, :execute, 1, fn %HTTP.Request{url: ^url}, _pool ->
        {:ok,
         %HTTP.Response{
           headers: %{
             "cache-control" => "private",
             "vary" => "something",
             "content-type" => "application/json"
           },
           status_code: 401,
           body: "{}"
         }}
      end)

      conn =
        conn(
          :get,
          "https://web-cdn.test.api.bbci.co.uk/election2023address/25050756"
        )
        |> put_req_header("x-bbc-edge-cdn", "1")
        |> Router.call([])

      assert conn.status == 401

      assert ["public, stale-if-error=90, stale-while-revalidate=30, max-age=5"] =
               get_resp_header(conn, "cache-control")

      assert ["Accept-Encoding"] = get_resp_header(conn, "vary")
      assert ["application/json"] = get_resp_header(conn, "content-type")
    end

    test "returns 400 on invalid postcode" do
      ec_endpoint = Application.get_env(:belfrage, :electoral_commission_endpoint)

      # assuming an invalid postcode
      url = "#{ec_endpoint}/api/v1/postcode/IP224DN/?token=f110d812b94d8cdf517765ff8657b89e8b08ebd6"

      expect(HTTPMock, :execute, 1, fn %HTTP.Request{url: ^url}, _pool ->
        {:ok,
         %HTTP.Response{
           headers: %{
             "cache-control" => "private",
             "vary" => "something",
             "content-type" => "application/json"
           },
           status_code: 400,
           body: ~s({"error":"Could not geocode from any source"})
         }}
      end)

      conn =
        conn(
          :get,
          "https://web-cdn.test.api.bbci.co.uk/election2023postcode/IP224DN"
        )
        |> put_req_header("x-bbc-edge-cdn", "1")
        |> Router.call([])

      assert conn.status == 400

      assert ["public, stale-if-error=90, stale-while-revalidate=30, max-age=5"] =
               get_resp_header(conn, "cache-control")

      assert ["Accept-Encoding"] = get_resp_header(conn, "vary")
      assert ["application/json"] = get_resp_header(conn, "content-type")
    end
  end
end
