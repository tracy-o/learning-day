defmodule Belfrage.SmokeTestCase do
  alias Test.Support.Helper
  import ExUnit.Assertions

  @stack_ids Application.get_env(:belfrage, :smoke)[:endpoint_to_stack_id_mapping]
  @expected_minimum_content_length 30
  @redirects_statuses Application.get_env(:belfrage, :redirect_statuses)

  def tld(host) do
    cond do
      String.ends_with?(host, ".com") -> ".com"
      String.ends_with?(host, ".co.uk") -> ".co.uk"
    end
  end

  def targets_for(environment) do
    Application.get_env(:belfrage, :smoke)[String.to_atom(environment)]
  end

  def normalise_example(path) when is_binary(path), do: {path, 200}

  def normalise_example({path, status_code}) when is_binary(path) and is_integer(status_code), do: {path, status_code}

  def assert_smoke_response(test_properties, response, expected_status_code) do
    assert response.status_code == expected_status_code

    if expected_status_code in @redirects_statuses do
      location_header = Helper.get_header(response.headers, "location")
      assert not is_nil(location_header) and String.length(location_header) > 0
    else
      assert not is_nil(response.body) and String.length(response.body) > @expected_minimum_content_length
    end

    refute {"belfrage-cache-status", "STALE"} in response.headers

    expected_stack_id_header = Map.get(@stack_ids, test_properties.target)
    assert Helper.header_item_exists(response.headers, expected_stack_id_header)
  end

  defmacro __using__(
             route_matcher: route_matcher,
             matcher_spec: matcher_spec,
             environments: environments
           ) do
    quote do
      use ExUnit.Case, async: true
      alias Test.Support.Helper
      import Belfrage.SmokeTestCase, only: [tld: 1, targets_for: 1, normalise_example: 1, assert_smoke_response: 3]

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
            {path, expected_status_code} = normalise_example(example)
            @path path
            @expected_status_code expected_status_code

            @tag route: @route_matcher
            @tag stack: @target
            test "#{path}", context do
              header_id = Application.get_env(:belfrage, :smoke)[:endpoint_to_stack_id_mapping][@target]

              resp = Helper.get_route(@host, @path, @matcher_spec.using)

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

                  assert_smoke_response(
                    test_properties,
                    resp,
                    @expected_status_code
                  )
              end
            end
          end
        end
      end
    end
  end
end
