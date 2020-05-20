defmodule BelfrageSmokeTest do
  use ExUnit.Case
  alias Test.Support.Helper

  @opts Application.get_env(:smoke, :opts)
  @moduletag :smoke_test

  setup do
    @opts
  end

  @tag belfrage_test: true
  describe "belfrage_test" do
    test "/sport/alpine-skiing", %{endpoint_belfrage: endpoint, header_belfrage: header_id} do
      resp = Helper.get_route(endpoint, "/sport/alpine-skiing")

      assert resp.status_code == 200
      assert Helper.header_item_exists(resp.headers, header_id)
      assert resp.body =~ "The home of Alpine Skiing on BBC Sport online"
    end

    test "/sport/videos/48521428", %{endpoint_gtm: endpoint, header_belfrage: header_id} do
      resp = Helper.get_route(endpoint, "/sport/videos/48521428")

      assert resp.status_code == 200
      assert Helper.header_item_exists(resp.headers, header_id)
      assert resp.body =~ "Bowlers star as Sri Lanka edge Afghanistan"
    end

    test "/tajik", %{endpoint_gtm_com: endpoint, header_belfrage: header_id} do
      resp = Helper.get_route(endpoint, "/tajik")

      assert resp.status_code == 200
      assert Helper.header_item_exists(resp.headers, header_id)
      assert resp.body =~ "Сафҳаи аслӣ - BBC Tajik/Persian"
    end
  end

  @tag belfrage_live: true
  describe "belfrage_live" do
    test "/sport/alpine-skiing", %{endpoint_belfrage_live: endpoint, header_belfrage: header_id} do
      resp = Helper.get_route(endpoint, "/sport/alpine-skiing")

      assert resp.status_code == 200
      assert Helper.header_item_exists(resp.headers, header_id)
      assert resp.body =~ "The home of Alpine Skiing on BBC Sport online"
    end

    test "/sport/videos/48521428", %{endpoint_gtm_live: endpoint, header_belfrage: header_id} do
      resp = Helper.get_route(endpoint, "/sport/videos/48521428")

      assert resp.status_code == 200
      assert Helper.header_item_exists(resp.headers, header_id)
      assert resp.body =~ "Bowlers star as Sri Lanka edge Afghanistan"
    end

    test "/tajik", %{endpoint_gtm_com_live: endpoint, header_belfrage: header_id} do
      resp = Helper.get_route(endpoint, "/tajik")

      assert resp.status_code == 200
      assert Helper.header_item_exists(resp.headers, header_id)
      assert resp.body =~ "Сафҳаи аслӣ - BBC Tajik/Persian"
    end
  end

  @tag "bruce-belfrage_test": true
  describe "bruce-belfrage_test" do
    test "/sport/alpine-skiing", %{endpoint_bruce: endpoint, header_bruce: header_id} do
      resp = Helper.get_route(endpoint, "/sport/alpine-skiing")

      assert resp.status_code == 200
      assert Helper.header_item_exists(resp.headers, header_id)
      assert resp.body =~ "The home of Alpine Skiing on BBC Sport online"
    end
  end

  @tag "bruce-belfrage_live": true
  describe "bruce-belfrage_live" do
    test "/sport/alpine-skiing", %{endpoint_bruce_live: endpoint, header_bruce: header_id} do
      resp = Helper.get_route(endpoint, "/sport/alpine-skiing")

      assert resp.status_code == 200
      assert Helper.header_item_exists(resp.headers, header_id)
      assert resp.body =~ "The home of Alpine Skiing on BBC Sport online"
    end
  end

  @tag "cedric-belfrage_live": true
  describe "cedric-belfrage_live" do
    test "/sport/alpine-skiing", %{endpoint_cedric_live: endpoint, header_cedric: header_id} do
      resp = Helper.get_route(endpoint, "/sport/alpine-skiing")

      assert resp.status_code == 200
      assert Helper.header_item_exists(resp.headers, header_id)
      assert resp.body =~ "The home of Alpine Skiing on BBC Sport online"
    end
  end
end
