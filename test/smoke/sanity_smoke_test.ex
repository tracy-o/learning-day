defmodule BelfrageSanitySmokeTest do
  @moduledoc """
  Tests for routes via the GTM, until `gtm` and `gtm_com`
  auto smoke tests are supported, by being added back in config/smoke_test.
  """
  use ExUnit.Case, async: true
  alias Test.Support.Helper

  @moduletag :smoke_test
  @moduletag :sanity

  @belfrage_header %{id: "bid", value: "www"}

  setup do
    %{smoke_env: System.get_env("SMOKE_ENV") || "test"}
  end

  describe "GTM sanity tests" do
    @describetag stack: "belfrage"
    test "GTM /sport/videos/48521428", %{smoke_env: smoke_env} do
      endpoint = gtm_host(smoke_env)

      resp = Helper.get_route(endpoint, "/sport/videos/48521428")

      assert resp.status_code == 200
      assert Helper.header_item_exists(resp.headers, @belfrage_header)
      assert resp.body =~ "Bowlers star as Sri Lanka edge Afghanistan"
    end

    test "GTM .com /tajik", %{smoke_env: smoke_env} do
      endpoint = gtm_host_com(smoke_env)
      resp = Helper.get_route(endpoint, "/tajik")

      assert resp.status_code == 200
      assert Helper.header_item_exists(resp.headers, @belfrage_header)
      assert resp.body =~ "Сафҳаи аслӣ - BBC Tajik/Persian"
    end
  end

  defp gtm_host("test"), do: "www.test.bbc.co.uk"
  defp gtm_host_com("test"), do: "www.test.bbc.com"

  defp gtm_host("live"), do: "www.bbc.co.uk"
  defp gtm_host_com("live"), do: "www.bbc.com"
end
