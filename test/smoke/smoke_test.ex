defmodule BelfrageSmokeTest do
  use ExUnit.Case, async: true
  alias Test.Support.Helper

  @moduletag :smoke_test
  @moduletag :sanity

  setup do
    smoke_env = System.get_env("SMOKE_ENV") || "test"

    Map.merge(Application.get_env(:smoke, String.to_atom(smoke_env)), Application.get_env(:smoke, :header))
    |> Map.merge(%{smoke_env: smoke_env})
  end

  describe "belfrage" do
    @describetag stack: "belfrage"
    test "/sport/alpine-skiing", %{endpoint_belfrage: endpoint, header_belfrage: header_id} do
      resp = Helper.get_route(endpoint, "/sport/alpine-skiing")

      assert resp.status_code == 200
      assert Helper.header_item_exists(resp.headers, header_id)
      assert resp.body =~ "The home of Alpine Skiing on BBC Sport online"
    end
  end

  describe "bruce-belfrage" do
    @describetag stack: "bruce-belfrage"
    test "/sport/alpine-skiing", %{endpoint_bruce: endpoint, header_bruce: header_id} do
      resp = Helper.get_route(endpoint, "/sport/alpine-skiing")

      assert resp.status_code == 200
      assert Helper.header_item_exists(resp.headers, header_id)
      assert resp.body =~ "The home of Alpine Skiing on BBC Sport online"
    end
  end

  describe "cedric-belfrage" do
    @describetag stack: "cedric-belfrage"
    test "/sport/alpine-skiing", %{endpoint_cedric: endpoint, header_cedric: header_id} do
      resp = Helper.get_route(endpoint, "/sport/alpine-skiing")

      assert resp.status_code == 200
      assert Helper.header_item_exists(resp.headers, header_id)
      assert resp.body =~ "The home of Alpine Skiing on BBC Sport online"
    end
  end

  describe "GTM" do
    @describetag stack: "gtm"
    test "WebCore .co.uk /sport/videos/48521428", %{header_belfrage: header_id, smoke_env: smoke_env} do
      endpoint = Helper.gtm_host(smoke_env)
      resp = Helper.get_route(endpoint, "/sport/videos/48521428")

      assert resp.status_code == 200
      assert Helper.header_item_exists(resp.headers, header_id)
      assert resp.body =~ "Bowlers star as Sri Lanka edge Afghanistan"
    end

    test "WebCore .com /sport/videos/48521428", %{header_belfrage: header_id, smoke_env: smoke_env} do
      endpoint = Helper.gtm_host_com(smoke_env)
      resp = Helper.get_route(endpoint, "/sport/videos/48521428")

      assert resp.status_code == 200
      assert Helper.header_item_exists(resp.headers, header_id)
      assert resp.body =~ "Bowlers star as Sri Lanka edge Afghanistan"
    end

    test "WS .com /tajik", %{header_belfrage: header_id, smoke_env: smoke_env} do
      endpoint = Helper.gtm_host_com(smoke_env)
      resp = Helper.get_route(endpoint, "/tajik")

      assert resp.status_code == 200
      assert Helper.header_item_exists(resp.headers, header_id)
      assert resp.body =~ "Сафҳаи аслӣ - BBC Tajik/Persian"
    end
  end

  describe "CDN" do
    @describetag stack: "cdn"
    test "web", %{header_cedric: header_id, smoke_env: smoke_env} do
      endpoint = Helper.cdn_web_host(smoke_env)

      resp =
        Helper.get_route(
          endpoint,
          "/fd/preview/sport-app-page?page=http%3A%2F%2Fwww.bbc.co.uk%2Fsport%2Fgymnastics.app&v=2&platform=ios"
        )

      assert resp.status_code == 200
      assert Helper.header_item_exists(resp.headers, header_id)
      assert Enum.any?(resp.headers, fn header -> header == {"content-type", "application/json; charset=utf-8"} end)
    end

    test "sport", %{header_cedric: header_id, smoke_env: smoke_env} do
      endpoint = Helper.cdn_sport_host(smoke_env)

      resp =
        Helper.get_route(
          endpoint,
          "/fd/preview/sport-app-page?page=http%3A%2F%2Fwww.bbc.co.uk%2Fsport%2Fgymnastics.app&v=2&platform=ios"
        )

      assert resp.status_code == 200
      assert Helper.header_item_exists(resp.headers, header_id)
      assert Enum.any?(resp.headers, fn header -> header == {"content-type", "application/json; charset=utf-8"} end)
    end

    test "news", %{header_cedric: header_id, smoke_env: smoke_env} do
      endpoint = Helper.cdn_news_host(smoke_env)

      resp =
        Helper.get_route(
          endpoint,
          "/fd/preview/sport-app-page?page=http%3A%2F%2Fwww.bbc.co.uk%2Fsport%2Fgymnastics.app&v=2&platform=ios"
        )

      assert resp.status_code == 200
      assert Helper.header_item_exists(resp.headers, header_id)
      assert Enum.any?(resp.headers, fn header -> header == {"content-type", "application/json; charset=utf-8"} end)
    end
  end
end
