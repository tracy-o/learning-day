defmodule EndToEnd.AblSpecSelectorTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox

  alias BelfrageWeb.Router
  alias Belfrage.Clients.{HTTPMock, HTTP.Response}

  setup do
    :ets.delete_all_objects(:cache)
    :ok
  end

  describe "request with Abl query string params" do
    test "returns AblData with WSContentPartition " do
      expect(HTTPMock, :execute, fn _, _origin ->
        payload = "{\"Fabl\": \"Data\"}"
        {:ok, %Response{status_code: 200, body: payload}}
      end)

      response_conn =
        :get
        |> conn(
          "/fd/abl?clientName=Hindi&clientVersion=pre-4&page=india-63495511&release=public-alpha&service=hindi&type=asset"
        )
        |> Router.call(routefile: Routes.Routefiles.Main.Live)

      assert ["AblData.Fabl.WSContentPartition"] = get_resp_header(response_conn, "routespec")
      assert {"AblData", "Fabl", "WSContentPartition"} = response_conn.assigns.route_spec
    end

    test "returns AblData with CPSNewsAssetPartition" do
      expect(HTTPMock, :execute, fn _, _origin ->
        payload = "{\"Fabl\": \"Data\"}"
        {:ok, %Response{status_code: 200, body: payload}}
      end)

      response_conn =
        :get
        |> conn(
          "/fd/abl?clientName=News&clientVersion=pre-4&page=india-63495511&release=public-alpha&service=news&type=asset"
        )
        |> Router.call(routefile: Routes.Routefiles.Main.Live)

      assert ["AblData.Fabl.CPSNewsAssetPartition"] = get_resp_header(response_conn, "routespec")
      assert {"AblData", "Fabl", "CPSNewsAssetPartition"} = response_conn.assigns.route_spec
    end

    test "returns AblData with ChrysalisNewsHomePagePartition" do
      expect(HTTPMock, :execute, fn _, _origin ->
        payload = "{\"Fabl\": \"Data\"}"
        {:ok, %Response{status_code: 200, body: payload}}
      end)

      response_conn =
        :get
        |> conn(
          "/fd/abl?clientName=Chrysalis&clientVersion=pre-4&page=chrysalis_discovery&release=public-alpha&service=news&type=index"
        )
        |> Router.call(routefile: Routes.Routefiles.Main.Live)

      assert ["AblData.Fabl.ChrysalisNewsHomePagePartition"] = get_resp_header(response_conn, "routespec")
      assert {"AblData", "Fabl", "ChrysalisNewsHomePagePartition"} = response_conn.assigns.route_spec
    end

    test "returns AblData with CatchAllPartition with invalid query params" do
      expect(HTTPMock, :execute, fn _, _origin ->
        payload = "{\"Fabl\": \"Data\"}"
        {:ok, %Response{status_code: 200, body: payload}}
      end)

      response_conn =
        :get
        |> conn(
          "/fd/abl?clientName=someName&clientVersion=pre-4&page=india-63495511&release=public-alpha&service=someService&type=someType"
        )
        |> Router.call(routefile: Routes.Routefiles.Main.Live)

      assert ["AblData.Fabl.CatchAllPartition"] = get_resp_header(response_conn, "routespec")
      assert {"AblData", "Fabl", "CatchAllPartition"} = response_conn.assigns.route_spec
    end
  end
end
