defmodule BelfrageChimneySmokeTest do
  @moduledoc """
  GTM & CDN smoke tests for ensuring all endpoints are covered.

   We don't automate those tests currently, because this will rely
   on the routes being added to the GTM. It's easier to pick a couple
   of routes that we know exist, and smoke test those for these endpoints.
  """
  use ExUnit.Case, async: true
  alias Test.Support.Helper

  @moduletag :smoke_test
  @moduletag :chimney

  @cedric_header Application.compile_env(:belfrage, :smoke)[:endpoint_to_stack_id_mapping]["cedric-belfrage"]
  @bruce_header Application.compile_env(:belfrage, :smoke)[:endpoint_to_stack_id_mapping]["bruce-belfrage"]
  @sally_header Application.compile_env(:belfrage, :smoke)[:endpoint_to_stack_id_mapping]["sally-belfrage"]

  describe "GTM tests" do
    @describetag stack: "gtm"

    @tag spec: "SportVideos"
    @tag platform: "Webcore"
    test "GTM /sport/av/cricket/48521428" do
      endpoint = Helper.gtm_host()

      resp = Helper.get_route(endpoint, "/sport/av/cricket/48521428")

      assert resp.status_code == 200
      assert Helper.header_item_exists(resp.headers, @bruce_header)
    end

    @tag spec: "WorldServiceTajik"
    @tag platform: "MozartNews"
    test "GTM .com /tajik" do
      endpoint = Helper.gtm_host_com()
      resp = Helper.get_route(endpoint, "/tajik")

      assert resp.status_code == 200
      assert Helper.header_item_exists(resp.headers, @sally_header)
    end
  end

  describe "CDN" do
    @describetag stack: "cdn"
    @describetag spec: "FablData"
    @describetag platform: "Fabl"

    test "web" do
      endpoint = Helper.cdn_web_host()

      resp =
        Helper.get_route(
          endpoint,
          "/fd/preview/sport-app-page?page=http%3A%2F%2Fwww.bbc.co.uk%2Fsport%2Fgymnastics.app&v=9&platform=ios"
        )

      assert resp.status_code == 200
      assert Helper.header_item_exists(resp.headers, @cedric_header)
      assert Helper.get_header(resp.headers, "content-type") == "application/json; charset=utf-8"
    end

    test "sport" do
      endpoint = Helper.cdn_sport_host()

      resp =
        Helper.get_route(
          endpoint,
          "/fd/preview/sport-app-page?page=http%3A%2F%2Fwww.bbc.co.uk%2Fsport%2Fgymnastics.app&v=9&platform=ios"
        )

      assert resp.status_code == 200
      assert Helper.header_item_exists(resp.headers, @cedric_header)
      assert Helper.get_header(resp.headers, "content-type") == "application/json; charset=utf-8"
    end

    test "news" do
      endpoint = Helper.cdn_news_host()

      resp =
        Helper.get_route(
          endpoint,
          "/fd/preview/sport-app-page?page=http%3A%2F%2Fwww.bbc.co.uk%2Fsport%2Fgymnastics.app&v=9&platform=ios"
        )

      assert resp.status_code == 200
      assert Helper.header_item_exists(resp.headers, @cedric_header)
      assert Helper.get_header(resp.headers, "content-type") == "application/json; charset=utf-8"
    end
  end
end
