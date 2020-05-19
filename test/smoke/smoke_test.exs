defmodule BelfrageSmokeTest do
  use ExUnit.Case
  alias Test.Support.Helper

  @opts Application.get_env(:smoke, :opts)
  @moduletag :smoke_test

  setup do
    @opts
  end

  describe "topics" do
    test "Belfrage /sport/alpine-skiing", %{endpoint_belfrage: endpoint, header_belfrage: header_id} do
      resp = Helper.get_route(endpoint, "/sport/alpine-skiing")

      assert resp.status_code == 200
      assert Helper.header_item_exists(resp.headers, header_id)
      assert resp.body =~ "The home of Alpine Skiing on BBC Sport online"
    end

    test "Belfrage /sport/snowboarding", %{endpoint_belfrage: endpoint, header_belfrage: header_id} do
      resp = Helper.get_route(endpoint, "/sport/snowboarding")

      assert resp.status_code == 200
      assert Helper.header_item_exists(resp.headers, header_id)
      assert resp.body =~ "The home of Snowboarding on BBC Sport online"
    end

    test "Bruce /sport/alpine-skiing", %{endpoint_bruce: endpoint, header_bruce: header_id} do
      resp = Helper.get_route(endpoint, "/sport/alpine-skiing")

      assert resp.status_code == 200
      assert Helper.header_item_exists(resp.headers, header_id)
      assert resp.body =~ "The home of Alpine Skiing on BBC Sport online"
    end

    test "Cedric /sport/alpine-skiing", %{endpoint_cedric: endpoint, header_cedric: header_id} do
      resp = Helper.get_route(endpoint, "/sport/alpine-skiing")

      assert resp.status_code == 200
      assert Helper.header_item_exists(resp.headers, header_id)
      assert resp.body =~ "The home of Alpine Skiing on BBC Sport online"
    end
  end

  describe "sfv" do
    test "/sport/videos/48521428", %{endpoint_gtm: endpoint, header_belfrage: header_id} do
      resp = Helper.get_route(endpoint, "/sport/videos/48521428")

      assert resp.status_code == 200
      assert Helper.header_item_exists(resp.headers, header_id)
      assert resp.body =~ "Bowlers star as Sri Lanka edge Afghanistan"
    end
  end

  describe "ws" do
    test "/tajik", %{endpoint_gtm_com: endpoint, header_belfrage: header_id} do
      resp = Helper.get_route(endpoint, "/tajik")

      assert resp.status_code == 200
      assert Helper.header_item_exists(resp.headers, header_id)
      assert resp.body =~ "Сафҳаи аслӣ - BBC Tajik/Persian"
    end
  end
end
