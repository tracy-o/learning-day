defmodule Belfrage.SmokeTest.Webcore.Www do
  use ExUnit.Case, async: true
  alias Test.Support.Helper

  @platform Webcore
  @stack "belfrage"

  @moduletag :smoke_test
  @moduletag platform: @platform
  @moduletag stack: @stack

  @ignore_specs ["Hcraes", "ContainerData", "PageComposition", "PresTest"]

  setup do
    smoke_env = if System.get_env("SMOKE_ENV"), do: System.get_env("SMOKE_ENV"), else: "test"
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
        test "spec: #{loop_id}, path: #{example}", %{endpoint_belfrage: endpoint, header_belfrage: header_id} do
          resp = Helper.get_route(endpoint, @example)

          assert resp.status_code == 200
          assert not is_nil(resp.body) and String.length(resp.body) > 32
          assert Helper.header_item_exists(resp.headers, header_id)
          refute Helper.header_item_exists(resp.headers, %{id: "bfa", value: "1"})
        end
      end
    end
  end)
end
