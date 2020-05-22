defmodule Belfrage.SmokeTest.Simorgh.Bruce do
  use ExUnit.Case, async: true
  alias Test.Support.Helper

  @platform Simorgh
  @stack "bruce-belfrage"

  @moduletag :smoke_test
  @moduletag platform: @platform
  @moduletag stack: @stack

  @ignore_specs []

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

        test "spec: #{loop_id}, path: #{example}", %{endpoint_bruce: endpoint} do
          resp = Helper.get_route(endpoint, @example)
          assert resp.status_code == 302
        end
      end
    end
  end)
end
