defmodule BelfrageChimneySmokeTest do
  @moduledoc """
  A couple of smoke tests for ensuring all endpoints are covered.
  """
  use ExUnit.Case, async: true
  alias Test.Support.Helper

  @moduletag :smoke_test
  @moduletag :chimney

  @belfrage_header Application.get_env(:smoke, :endpoint_to_stack_id_mapping)["belfrage"]
  @cedric_header Application.get_env(:smoke, :endpoint_to_stack_id_mapping)["cedric"]

  setup do
    %{smoke_env: System.get_env("SMOKE_ENV") || "test"}
  end

  describe "GTM tests" do
    @describetag stack: "gtm"
    test "GTM /sport/videos/48521428", %{smoke_env: smoke_env} do
      endpoint = Helper.gtm_host(smoke_env)

      resp = Helper.get_route(endpoint, "/sport/videos/48521428")

      assert resp.status_code == 200
      assert Helper.header_item_exists(resp.headers, @belfrage_header)
      assert resp.body =~ "Bowlers star as Sri Lanka edge Afghanistan"
    end

    test "GTM .com /tajik", %{smoke_env: smoke_env} do
      endpoint = Helper.gtm_host_com(smoke_env)
      resp = Helper.get_route(endpoint, "/tajik")

      assert resp.status_code == 200
      assert Helper.header_item_exists(resp.headers, @belfrage_header)
      assert resp.body =~ "Сафҳаи аслӣ - BBC Tajik/Persian"
    end
  end

  describe "CDN" do
    @describetag stack: "cdn"
    test "web", %{smoke_env: smoke_env} do
      endpoint = Helper.cdn_web_host(smoke_env)

      resp =
        Helper.get_route(
          endpoint,
          "/fd/preview/sport-app-page?page=http%3A%2F%2Fwww.bbc.co.uk%2Fsport%2Fgymnastics.app&v=2&platform=ios"
        )

      assert resp.status_code == 200
      assert Helper.header_item_exists(resp.headers, @cedric_header)
      assert Helper.get_header(resp.headers, "content-type") == "application/json; charset=utf-8"
    end

    test "sport", %{smoke_env: smoke_env} do
      endpoint = Helper.cdn_sport_host(smoke_env)

      resp =
        Helper.get_route(
          endpoint,
          "/fd/preview/sport-app-page?page=http%3A%2F%2Fwww.bbc.co.uk%2Fsport%2Fgymnastics.app&v=2&platform=ios"
        )

      assert resp.status_code == 200
      assert Helper.header_item_exists(resp.headers, @cedric_header)
      assert Helper.get_header(resp.headers, "content-type") == "application/json; charset=utf-8"
    end

    test "news", %{smoke_env: smoke_env} do
      endpoint = Helper.cdn_news_host(smoke_env)

      resp =
        Helper.get_route(
          endpoint,
          "/fd/preview/sport-app-page?page=http%3A%2F%2Fwww.bbc.co.uk%2Fsport%2Fgymnastics.app&v=2&platform=ios"
        )

      assert resp.status_code == 200
      assert Helper.header_item_exists(resp.headers, @cedric_header)
      assert Helper.get_header(resp.headers, "content-type") == "application/json; charset=utf-8"
    end
  end
end
