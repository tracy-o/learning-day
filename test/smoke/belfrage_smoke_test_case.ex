defmodule Belfrage.SmokeTestCase do
  alias Test.Support.Helper
  alias Belfrage.SmokeTestCase.Expectations
  import ExUnit.Assertions

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
    case Expectations.expect_smoke_response(test_properties, response, expected_status_code) do
      {true, _} -> assert true
      {false, msg} -> assert false, msg
    end

    assert true
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

              case Helper.get_route(@host, @path, @matcher_spec.using) do
                {:ok, resp} ->
                  test_properties = %{
                    matcher: @matcher_spec,
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

                {:error, reason} ->
                  assert false
              end
            end
          end
        end
      end
    end
  end
end
