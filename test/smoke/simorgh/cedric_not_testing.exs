defmodule Belfrage.SmokeTest.Simorgh.Cedric do
  use ExUnit.Case, async: true
  alias Test.Support.Helper

  @platform Simorgh
  @stack "cedric-belfrage"

  @moduletag :smoke_test
  @moduletag platform: @platform
  @moduletag stack: @stack

  @ignore_specs []

  setup do
    smoke_env = System.get_env("SMOKE_ENV") || "test"
    Map.merge(Application.get_env(:smoke, String.to_atom(smoke_env)), Application.get_env(:smoke, :header))
  end

  Routes.Routefile.routes()
  |> Enum.filter(&(Belfrage.RouteSpec.specs_for(elem(&1, 1))[:platform] == @platform))
  |> Enum.each(fn {route_matcher, loop_id, examples} ->
    describe "#{@stack} route: #{route_matcher}," do
      @describetag spec: loop_id

      for example <- examples, loop_id not in @ignore_specs do
        @example example

        @tag route: route_matcher
        test "spec: #{loop_id}, path: #{example}", %{endpoint_cedric: endpoint, header_cedric: header_id} do
          resp = Helper.get_route(endpoint, @example)
          redirect_endpoint = endpoint |> String.replace(".co.uk", ".com")

          assert resp.status_code == 302
          assert Helper.header_item_exists(resp.headers, header_id)
          assert Helper.header_item_exists(resp.headers, %{id: "location", value: redirect_endpoint <> @example})
        end
      end
    end
  end)
end
