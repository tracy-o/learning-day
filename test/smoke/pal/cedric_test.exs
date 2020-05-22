defmodule Belfrage.SmokeTest.Pal.Cedric do
  use ExUnit.Case, async: true
  alias Test.Support.Helper
  alias Belfrage.RouteSpec

  @platform Pal
  @stack "cedric-belfrage"

  @moduletag :smoke_test
  @moduletag platform: @platform
  @moduletag stack: @stack

  # not testing WorldServiceMundo (Pal) due to issue on Bruce/Cedric
  # involving "WorldServiceRedirect"
  # instead of redirection, Belfrage returns 200/404/500 for routes example
  @ignore_specs ["WorldServiceMundo"]

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
        @loop_id loop_id

        @tag route: route_matcher
        test "spec: #{loop_id}, path: #{example}", %{
          endpoint_cedric: endpoint,
          header_cedric: header_id,
          endpoint_pal: endpoint_pal
        } do
          resp = Helper.get_route(endpoint, @example)
          assert Helper.header_item_exists(resp.headers, header_id)

          world_service_redirect? = RouteSpec.specs_for(@loop_id)[:pipeline] |> Enum.member?("WorldServiceRedirect")

          case {endpoint_pal, world_service_redirect?} do
            {"https://pal.live.bbc.co.uk", false} ->
              assert resp.status_code == 200
              assert not is_nil(resp.body) and String.length(resp.body) > 32
              refute Helper.header_item_exists(resp.headers, %{id: "bfa", value: "1"})

            _ ->
              redirect_endpoint =
                case world_service_redirect? do
                  true -> endpoint |> String.replace(".co.uk", ".com")
                  false -> endpoint_pal
                end

              assert resp.status_code in [301, 302]
              assert Helper.header_item_exists(resp.headers, %{id: "location", value: redirect_endpoint <> @example})
          end
        end
      end
    end
  end)
end
