defmodule Belfrage.SmokeTestCase do
  def tld(host) do
    cond do
      String.ends_with?(host, ".com") -> ".com"
      String.ends_with?(host, ".co.uk") -> ".co.uk"
    end
  end

  def targets_for(environment) do
    Application.get_env(:smoke, String.to_atom(environment))
  end

  defmacro __using__(
             opts = [
               route_matcher: route_matcher,
               matcher_spec: matcher_spec,
               environments: environments
             ]
           ) do
    quote do
      use ExUnit.Case, async: true
      alias Test.Support.Helper
      import Belfrage.SmokeTestCase, only: [tld: 1, targets_for: 1]
      @route_matcher unquote(route_matcher)
      @matcher_spec unquote(matcher_spec)
      @environments unquote(environments)

      for smoke_env <- @environments, {target, host} <- targets_for(smoke_env) do
        @target target
        @smoke_env smoke_env
        @host host

        describe "#{@matcher_spec.using} #{@route_matcher} against #{@smoke_env} #{@target}" do
          @describetag spec: @matcher_spec.using
          @describetag platform: Belfrage.RouteSpec.specs_for(@matcher_spec.using, smoke_env).platform

          for example <- @matcher_spec.examples do
            @example example

            @tag route: @route_matcher
            @tag stack: @target
            test "#{example}" do
              header_id = Application.get_env(:smoke, :endpoint_to_stack_id_mapping)[@target]

              resp = Helper.get_route(@host, @example)

              cond do
                @smoke_env == "live" and @matcher_spec.only_on == "test" ->
                  assert resp.status_code == 404
                  assert Helper.header_item_exists(resp.headers, header_id)

                true ->
                  test_properties = %{
                    using: @matcher_spec.using,
                    smoke_env: @smoke_env,
                    target: @target,
                    host: @host,
                    tld: tld(@host)
                  }

                  results = Support.Smoke.Rules.run_assertions(test_properties, resp)

                  assert Support.Smoke.Rules.passed?(results), Support.Smoke.Rules.format_failures(results)
              end
            end
          end
        end
      end
    end
  end
end
