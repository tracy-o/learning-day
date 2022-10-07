defmodule Belfrage.SmokeTestCase do
  alias Test.Support.Helper
  alias Belfrage.SmokeTestCase.Expectations
  import ExUnit.Assertions

  @retry_times 0
  @retry_interval 1_000

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

  def truncate_path(path) do
    if String.length(path) > 100 do
      "#{String.slice(path, 0, 25)}...#{String.slice(path, -25, 25)}"
    else
      path
    end
  end

  def retry_route(endpoint, path, spec, retry_check) do
    Enum.reduce_while(@retry_times..0, {:error, "no response"}, fn times, _prev_resp ->
      with {:ok, resp} <- Helper.get_route(endpoint, path, spec),
           {true, _} <- retry_check.(resp) do
        {:halt, {:ok, resp}}
      else
        {_, reason} ->
          if times > 0 do
            IO.puts("[🐡] retry #{@retry_times - times + 1}/#{@retry_times}: #{path}")
            Process.sleep(@retry_interval)
            {:cont, {:error, reason}}
          else
            {:halt, {:error, reason}}
          end
      end
    end)
  end

  defmacro __using__(
             route_matcher: route_matcher,
             matcher_spec: matcher_spec,
             environments: environments
           ) do
    quote do
      use ExUnit.Case, async: true
      alias Test.Support.Helper

      import Belfrage.SmokeTestCase,
        only: [truncate_path: 1, tld: 1, targets_for: 1, normalise_example: 1, retry_route: 4]

      @route_matcher unquote(route_matcher)
      @matcher_spec unquote(matcher_spec)
      @environments unquote(environments)

      for smoke_env <- @environments, {target, host} <- targets_for(smoke_env) do
        @target target
        @smoke_env smoke_env
        @host host

        describe "#{@matcher_spec.using} #{@route_matcher} against #{@smoke_env} #{target}" do
          @describetag spec: @matcher_spec.using
          @describetag platform: Belfrage.RouteSpec.specs_for(@matcher_spec.using, smoke_env).platform

          for example <- @matcher_spec.examples do
            {path, expected_status_code} = normalise_example(example)
            @path path
            @expected_status_code expected_status_code

            @tag route: @route_matcher
            @tag stack: @target
            test "#{truncate_path(path)}", context do
              test_properties = %{
                matcher: @matcher_spec,
                smoke_env: @smoke_env,
                target: @target,
                host: @host,
                tld: tld(@host)
              }

              retry_check = fn resp ->
                Expectations.expect_response(test_properties, resp, @expected_status_code)
              end

              case retry_route(@host, @path, @matcher_spec, retry_check) do
                {:ok, resp} ->
                  assert true

                {:error, reason} when is_binary(reason) ->
                  assert false, reason

                {:error, reason} ->
                  assert false, inspect(reason)
              end
            end
          end
        end
      end
    end
  end
end
