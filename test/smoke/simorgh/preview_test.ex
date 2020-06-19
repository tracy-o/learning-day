defmodule Belfrage.SmokeTest.Simorgh.Preview do
  use ExUnit.Case, async: true
  alias Test.Support.Helper
  alias Belfrage.RouteSpec

  @platform Simorgh
  @stack "belfrage-preview"
  @smoke_env System.get_env("SMOKE_ENV") || "test"
  @ignore_specs Application.get_env(:smoke, :ignore_specs, [])

  @moduletag :smoke_test
  @moduletag platform: @platform
  @moduletag stack: @stack

  setup_all do
    Map.merge(Application.get_env(:smoke, String.to_atom(@smoke_env)), Application.get_env(:smoke, :header))
  end

  Routes.Routefile.routes()
  |> Enum.filter(fn {_, %{using: loop_id}} -> RouteSpec.specs_for(loop_id)[:platform] == @platform end)
  |> Enum.each(fn {route_matcher, %{using: loop_id, examples: examples}} ->
    describe "#{@stack} (#{@smoke_env}) route: #{route_matcher}," do
      @describetag spec: loop_id

      for example <- examples, loop_id not in @ignore_specs and @smoke_env == "test" do
        @example example

        @tag route: route_matcher
        test "spec: #{loop_id}, path: #{example}", %{endpoint_preview: endpoint, header_preview: header_id} do
          resp = Helper.get_route(endpoint, @example)

          redirect_endpoint = endpoint |> String.replace(".co.uk", ".com")

          assert resp.status_code == 302
          assert Helper.header_item_exists(resp.headers, header_id)

          assert Helper.header_item_exists(resp.headers, %{
                   id: "location",
                   value: "https://" <> redirect_endpoint <> @example
                 })
        end
      end
    end
  end)
end
