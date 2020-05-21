defmodule BelfrageSmokeTest do
  use ExUnit.Case
  alias Test.Support.Helper

  @moduletag :smoke_test

  setup do
    smoke_env = if System.get_env("SMOKE_ENV"), do: System.get_env("SMOKE_ENV"), else: "test"
    Map.merge(Application.get_env(:smoke, String.to_atom(smoke_env)), Application.get_env(:smoke, :header))
  end

  describe "belfrage" do
    @describetag stack: "belfrage"
    test "/sport/alpine-skiing", %{endpoint_belfrage: endpoint, header_belfrage: header_id} do
      resp = Helper.get_route(endpoint, "/sport/alpine-skiing")

      assert resp.status_code == 200
      assert Helper.header_item_exists(resp.headers, header_id)
      assert resp.body =~ "The home of Alpine Skiing on BBC Sport online"
    end

    test "GTM /sport/videos/48521428", %{endpoint_gtm: endpoint, header_belfrage: header_id} do
      resp = Helper.get_route(endpoint, "/sport/videos/48521428")

      assert resp.status_code == 200
      assert Helper.header_item_exists(resp.headers, header_id)
      assert resp.body =~ "Bowlers star as Sri Lanka edge Afghanistan"
    end

    test "GTM .com /tajik", %{endpoint_gtm_com: endpoint, header_belfrage: header_id} do
      resp = Helper.get_route(endpoint, "/tajik")

      assert resp.status_code == 200
      assert Helper.header_item_exists(resp.headers, header_id)
      assert resp.body =~ "Сафҳаи аслӣ - BBC Tajik/Persian"
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
end
