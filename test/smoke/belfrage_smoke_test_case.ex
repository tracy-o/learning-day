defmodule Belfrage.SmokeTestCase do
  def tld(host) do
    cond do
      String.ends_with?(host, ".com") -> ".com"
      String.ends_with?(host, ".co.uk") -> ".co.uk"
    end
  end

  defmacro __using__(
             opts = [
               route_matcher: route_matcher,
               matcher_spec: matcher_spec,
               targets: targets,
               environments: environments
             ]
           ) do
    quote do
      use ExUnit.Case, async: true
      alias Test.Support.Helper
      @route_matcher unquote(route_matcher)
      @matcher_spec unquote(matcher_spec)
      @environments unquote(environments)
      @targets unquote(targets)

      for target <- @targets, environment <- @environments do
        @target target
        @smoke_env environment
        @host Application.get_env(:smoke, String.to_atom(@smoke_env))[@target]

        describe "#{@matcher_spec.using} #{@route_matcher} against #{@smoke_env} #{@target}" do
          @describetag spec: @matcher_spec.using

          for example <- @matcher_spec.examples do
            @example example

            @tag route: @route_matcher
            @tag stack: @target
            test "#{example}" do
              header_id = Application.get_env(:smoke, :header)[@target]

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
                    tld: Belfrage.SmokeTestCase.tld(@host)
                  }

                  results = Belfrage.Smoke.Rules.run_assertions(test_properties, resp)

                  assert Belfrage.Smoke.Rules.passed?(results), Belfrage.Smoke.Rules.format_failures(results)
              end
            end
          end
        end
      end
    end
  end
end
