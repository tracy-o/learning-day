defmodule EndToEnd.MvtTest do
  use ExUnit.Case
  use Plug.Test
  alias BelfrageWeb.Router
  alias Belfrage.RouteState
  use Test.Support.Helper, :mox

  @moduletag :end_to_end

  @lambda_response %{
    "headers" => %{
      "cache-control" => "public, max-age=30",
      "vary" => "mvt-button_colour"
    },
    "statusCode" => 200,
    "body" => "<h1>Hello from the Lambda!</h1>"
  }

  defp expect_lambda_call(opts) do
    times_called = Keyword.get(opts, :times_called, 1)
    expected_headers = Keyword.get(opts, :headers, %{})

    Belfrage.Clients.LambdaMock
    |> expect(:call, times_called, fn _lambda_name, _role_arn, %{headers: actual_headers}, _request_id, _opts ->
      for {expected_key, expected_value} <- expected_headers do
        assert actual_headers[expected_key] == expected_value
      end

      {:ok, @lambda_response}
    end)
  end

  setup do
    :ets.delete_all_objects(:cache)
    start_supervised!({RouteState, "WebCoreMvtPlayground"})
    :ok
  end

  describe "when page uses mvt headers" do
    test "the response will vary on the mapped numeric mvt header" do
      expect_lambda_call(times_called: 1)

      response =
        conn(:get, "/mvt")
        |> put_req_header("bbc-mvt-1", "experiment;button_colour;red")
        |> put_req_header("bbc-mvt-5", "feature;sidebar;false")
        |> Router.call([])

      [vary_header] = get_resp_header(response, "vary")

      assert String.contains?(vary_header, "bbc-mvt-1")
      refute String.contains?(vary_header, "bbc-mvt-5")
    end
  end
end
