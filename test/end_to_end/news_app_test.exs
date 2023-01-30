defmodule EndToEnd.NewsAppsTest do
  use ExUnit.Case, async: false
  use Plug.Test
  alias BelfrageWeb.Router
  use Test.Support.Helper, :mox

  alias Belfrage.Clients.{HTTP, HTTPMock}
  alias Belfrage.Utils.Current

  @moduletag :end_to_end

  @fabl_endpoint Application.compile_env(:belfrage, :fabl_endpoint)

  describe "when the NewsAppsHardcodedResponse dial is enabled" do
    test "returns a hardcoded payload" do
      stub_dials(news_apps_hardcoded_response: "enabled")

      response_conn = conn(:get, "/fd/abl") |> Router.call([])

      {200, _resp_headers, body} = sent_resp(response_conn)

      assert body =~ "CallToActionBanner"

      assert ["application/json; charset=utf-8"] ==
               get_resp_header(response_conn, "content-type")

      assert ["public, stale-if-error=90, stale-while-revalidate=30, max-age=5"] ==
               get_resp_header(response_conn, "cache-control")
    end

    test "returns the same epoch when requests are within the same hour" do
      Current.Mock.freeze(~D[2022-12-02], ~T[11:14:52.368815Z])
      Belfrage.NewsApps.Failover.update()

      stub_dials(news_apps_hardcoded_response: "enabled")

      response_conn1 = conn(:get, "/fd/abl") |> Router.call([])
      {200, _resp_headers, body} = sent_resp(response_conn1)

      body_t1 = body |> Json.decode!()

      assert body_t1["data"]["metadata"]["lastUpdated"] == 1_669_978_800_000

      # 20 mins later...
      Current.Mock.freeze(~D[2022-12-02], ~T[11:34:56.368815Z])
      Belfrage.NewsApps.Failover.update()

      response_conn2 = conn(:get, "/fd/abl") |> Router.call([])
      {200, _resp_headers, body} = sent_resp(response_conn2)

      body_t2 = body |> Json.decode!()
      assert body_t1 == body_t2
      on_exit(&Current.Mock.unfreeze/0)
    end

    test "returns a different epoch when requests are over two different hours" do
      Current.Mock.freeze(~D[2022-12-02], ~T[11:58:52.368815Z])
      Belfrage.NewsApps.Failover.update()

      stub_dials(news_apps_hardcoded_response: "enabled")

      response_conn1 = conn(:get, "/fd/abl") |> Router.call([])
      {200, _resp_headers, body} = sent_resp(response_conn1)

      body_t1 = body |> Json.decode!()

      assert body_t1["data"]["metadata"]["lastUpdated"] == 1_669_978_800_000

      Current.Mock.freeze(~D[2022-12-02], ~T[12:01:16.368815Z])
      Belfrage.NewsApps.Failover.update()

      response_conn2 = conn(:get, "/fd/abl") |> Router.call([])
      {200, _resp_headers, body} = sent_resp(response_conn2)

      body_t2 = body |> Json.decode!()

      assert body_t1 != body_t2
      on_exit(&Current.Mock.unfreeze/0)
    end
  end

  describe "when the NewsAppsHardcodedResponse dial is disabled" do
    test "does not return an hardcoded payload" do
      stub_dials(news_apps_hardcoded_response: "disabled")

      url = "#{@fabl_endpoint}/module/abl"

      expect(HTTPMock, :execute, 1, fn %HTTP.Request{url: ^url}, _pool ->
        {:ok,
         %HTTP.Response{
           headers: %{},
           status_code: 200,
           body: "OK"
         }}
      end)

      conn(:get, "/fd/abl") |> Router.call([])
    end
  end

  describe "when the NewsAppsVarianceReducer dial is enabled" do
    test "removes the 'clientLoc' query string param" do
      stub_dials(news_apps_variance_reducer: "enabled")

      # to keep requests deterministic, query string get sorted
      sorted_qs =
        "clientName=Chrysalis&clientNeedsUpdate=true&clientVersion=pre-4&page=chrysalis_discovery&release=team&segmentId=70022f59ab_10&service=news&type=index"

      url = "#{@fabl_endpoint}/module/abl?#{sorted_qs}"

      expect(HTTPMock, :execute, 1, fn %HTTP.Request{url: ^url}, _pool ->
        {:ok,
         %HTTP.Response{
           headers: %{},
           status_code: 200,
           body: "OK"
         }}
      end)

      conn(
        :get,
        "/fd/abl?clientName=Chrysalis&clientVersion=pre-4&release=team&type=index&page=chrysalis_discovery&service=news&segmentId=70022f59ab_10&clientLoc=E7&clientNeedsUpdate=true"
      )
      |> Router.call([])
    end
  end

  describe "when the NewsAppsVarianceReducer dial is disabled" do
    test "does not remove the 'clientLoc' query string param" do
      stub_dials(news_apps_variance_reducer: "disabled")

      # to keep requests deterministic, query string get sorted
      sorted_qs =
        "clientLoc=E7&clientName=Chrysalis&clientNeedsUpdate=true&clientVersion=pre-4&page=chrysalis_discovery&release=team&segmentId=70022f59ab_10&service=news&type=index"

      url = "#{@fabl_endpoint}/module/abl?#{sorted_qs}"

      expect(HTTPMock, :execute, 1, fn %HTTP.Request{url: ^url}, _pool ->
        {:ok,
         %HTTP.Response{
           headers: %{},
           status_code: 200,
           body: "OK"
         }}
      end)

      conn(
        :get,
        "/fd/abl?clientName=Chrysalis&clientVersion=pre-4&release=team&type=index&page=chrysalis_discovery&service=news&segmentId=70022f59ab_10&clientLoc=E7&clientNeedsUpdate=true"
      )
      |> Router.call([])
    end
  end
end
