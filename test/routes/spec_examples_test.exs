defmodule Routes.SpecExamplesTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox
  import Belfrage.Test.StubHelper
  import Test.Support.Helper, only: [set_logging_level: 1]

  import Mock

  alias BelfrageWeb.Router
  alias Belfrage.{RouteSpecManager, PreflightTransformers, Envelope}

  @moduletag :routes_test

  @examples RouteSpecManager.list_examples()

  describe "spec" do
    setup do
      start_supervised!({Belfrage.RouteState, {{"HomePage", "Webcore"}, %{}}})
      :ok
    end

    test "examples are prefixed with a '/'" do
      validate(@examples, fn example ->
        if String.starts_with?(example.path, "/") do
          :ok
        else
          {:error, "Example #{example.path} for route #{example.spec} must start with a '/'"}
        end
      end)
    end

    test "examples are routed correctly" do
      set_logging_level(:error)
      stub_origins()
      stub_dial(:bbcx_enabled, "true")

      @examples
      |> Enum.reject(fn %{spec: spec} -> spec == "ProxyPass" end)
      |> validate(&validate_example/1)
    end

    test "proxy-pass examples are routed correctly" do
      [spec] = RouteSpecManager.get_spec("ProxyPass").specs

      validate(spec.examples, fn example ->
        conn = make_call(:get, example.path, example.headers)

        if conn.status == 404 && conn.resp_body =~ "404" do
          :ok
        else
          {:error, "Example #{example.path} for route #{example.spec} is not routed correctly.
             Response status: #{conn.status}. Body: #{conn.resp_body}"}
        end
      end)
    end
  end

  defp validate(items, validator) do
    errors =
      items
      |> Enum.map(validator)
      |> Enum.reduce([], fn el, acc ->
        case el do
          {:error, error} ->
            [error | acc]

          _ ->
            acc
        end
      end)

    unless errors == [] do
      errors
      |> List.flatten()
      |> Enum.map_join("\n", &"* #{&1}")
      |> flunk()
    end
  end

  defp validate_example(example) do
    resp_headers = maybe_mock_preflight_and_call(example).resp_headers

    case :proplists.get_value("routespec", resp_headers, nil) do
      nil ->
        {:error, "Example #{example.path} for route #{example.spec} was not routed.
                  There is no routespec in response headers"}

      resp_route_spec ->
        [resp_spec, resp_platform | _partition] = String.split(resp_route_spec, ".")

        case {example.spec, example.platform} do
          {^resp_spec, ^resp_platform} ->
            :ok

          _other ->
            {:error, "Example #{example.path} for route #{example.spec} is not routed correctly.
                      Response routespec header: #{resp_route_spec}"}
        end
    end
  end

  # 'mock_preflight_transformer_map' must incorporate mapping specifications for preflight
  # transformers that interact with external downstream services.
  # For each specification included in the mock map, the corresponding preflight transformer
  # will be mocked to provide platform-specific responses for the current example.
  # This approach avoids the need to mock downstream service calls for every example that
  # utilizes preflight transformers, as the preflight transformer itself will be mocked
  # based on the specific platform being considered in each case.
  @mock_preflight_transformer_map %{
    "BitesizeSubjects" => BitesizeSubjectsPlatformSelector,
    "NewsArticlePage" => AssetTypePlatformSelector
  }

  defp maybe_mock_preflight_and_call(example) do
    case Map.get(@mock_preflight_transformer_map, example.spec) do
      nil ->
        make_call(:get, example.path, example.headers)

      transformer_module ->
        with_mock(
          Module.concat([PreflightTransformers, transformer_module]),
          call: fn envelope -> {:ok, Envelope.add(envelope, :private, %{platform: example.platform})} end
        ) do
          make_call(:get, example.path, example.headers)
        end
    end
  end

  defp make_call(method, path, headers) do
    conn(method, path)
    |> put_headers(headers)
    |> Router.call([])
  end

  defp put_headers(conn, headers) do
    Enum.reduce(headers, conn, fn {header, value}, conn_acc ->
      put_req_header(conn_acc, header, value)
    end)
  end
end
