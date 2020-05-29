defmodule Belfrage.SmokeTest.Webcore.Www do
  use ExUnit.Case, async: true
  alias Test.Support.Helper
  alias Belfrage.RouteSpec

  @platform Webcore
  @stack "belfrage"
  @smoke_env System.get_env("SMOKE_ENV") || "test"
  @ignore_specs Application.get_env(:smoke, :ignore_specs, [])

  @moduletag :smoke_test
  @moduletag platform: @platform
  @moduletag stack: @stack

  setup_all do
    Map.merge(
      Application.get_env(:smoke, String.to_atom(@smoke_env)),
      Application.get_env(:smoke, :header)
    )
  end

  Routes.Routefile.routes_with_env()
  |> Enum.filter(fn {_, %{using: loop_id}} -> RouteSpec.specs_for(loop_id)[:platform] == @platform end)
  |> Enum.each(fn {route_matcher, %{using: loop_id, examples: examples, only_on: env}} ->
    describe "#{@stack} (#{@smoke_env}) route: #{route_matcher}," do
      @describetag spec: loop_id

      for example <- examples, loop_id not in @ignore_specs do
        @example example
        @only_on env

        @tag route: route_matcher
        test "spec: #{loop_id}, path: #{example}", %{endpoint_belfrage: endpoint, header_belfrage: header_id} do
          resp = Helper.get_route(endpoint, @example)

          cond do
            @smoke_env == "live" and @only_on == "test" ->
              assert resp.status_code == 404
              assert Helper.header_item_exists(resp.headers, header_id)

            true ->
              assert resp.status_code == 200
              assert not is_nil(resp.body) and String.length(resp.body) > 32
              assert Helper.header_item_exists(resp.headers, header_id)
              refute Helper.header_item_exists(resp.headers, %{id: "bfa", value: "1"})
          end
        end
      end
    end
  end)
end
