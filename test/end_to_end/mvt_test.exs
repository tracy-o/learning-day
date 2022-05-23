defmodule EndToEnd.MvtTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox
  import Test.Support.Helper, only: [set_environment: 1]

  alias BelfrageWeb.Router
  alias Belfrage.RouteState
  alias Belfrage.Mvt

  @moduletag :end_to_end

  defp expect_lambda_call(opts) do
    times_called = Keyword.get(opts, :times_called, 1)
    expected_headers = Keyword.get(opts, :headers, %{})
    vary_response = Keyword.get(opts, :vary_response)

    Belfrage.Clients.LambdaMock
    |> expect(:call, times_called, fn _lambda_name, _role_arn, %{headers: actual_headers}, _request_id, _opts ->
      for {expected_key, expected_value} <- expected_headers do
        assert actual_headers[expected_key] == expected_value
      end

      {:ok, lambda_response(vary_response: vary_response)}
    end)
  end

  defp lambda_response(opts) do
    vary_response = Keyword.get(opts, :vary_response, "")

    %{
      "headers" => %{
        "cache-control" => "public, max-age=30",
        "vary" => vary_response
      },
      "statusCode" => 200,
      "body" => "<h1>Hello from the Lambda!</h1>"
    }
  end

  defp set_mvt_slot(slots) do
    Mvt.Slots.set(%{"1" => slots})
    on_exit(fn -> Mvt.Slots.set(%{}) end)
    :ok
  end

  setup do
    :ets.delete_all_objects(:cache)
    start_supervised!({RouteState, "WebCoreMvtPlayground"})
    :ok
  end

  describe "when on live environment and lambda returns expected vary header" do
    setup do
      set_environment("live")
      set_mvt_slot([%{"header" => "bbc-mvt-1", "key" => "button_colour"}])
    end

    test "the response will vary on the mapped numeric mvt header" do
      expect_lambda_call(times_called: 1, vary_response: "mvt-button_colour,mvt-sidebar")

      response =
        conn(:get, "/mvt")
        |> put_req_header("bbc-mvt-1", "experiment;button_colour;red")
        |> put_req_header("bbc-mvt-5", "feature;sidebar;false")
        |> Router.call([])

      [vary_header] = get_resp_header(response, "vary")

      assert String.contains?(vary_header, "bbc-mvt-1")
      refute String.contains?(vary_header, "bbc-mvt-5")
    end

    test "the response will not vary on override mvt headers" do
      expect_lambda_call(times_called: 1, vary_response: "mvt-some_experiment")

      response =
        conn(:get, "/mvt")
        |> put_req_header("mvt-some_experiment", "experiment;some_value")
        |> Router.call([])

      [vary_header] = get_resp_header(response, "vary")

      refute String.contains?(vary_header, "mvt-some_experiment")
    end
  end

  describe "when on live environment and lambda returns vary header which doesn't match any mvt header" do
    setup do
      set_environment("live")
      set_mvt_slot([%{"header" => "bbc-mvt-1", "key" => "button_colour"}])
    end

    test "the response will not vary on the mapped numeric mvt header" do
      expect_lambda_call(times_called: 1, vary_response: "mvt-wrong_response")

      response =
        conn(:get, "/mvt")
        |> put_req_header("bbc-mvt-1", "experiment;button_colour;red")
        |> put_req_header("bbc-mvt-5", "feature;sidebar;false")
        |> Router.call([])

      [vary_header] = get_resp_header(response, "vary")

      refute String.contains?(vary_header, "bbc-mvt-1")
      refute String.contains?(vary_header, "bbc-mvt-5")
      refute String.contains?(vary_header, "mvt-wrong_response")
    end

    test "the response will not vary on override mvt headers" do
      expect_lambda_call(times_called: 1, vary_response: "mvt-some_experiment")

      response =
        conn(:get, "/mvt")
        |> put_req_header("mvt-some_experiment", "experiment;some_value")
        |> Router.call([])

      [vary_header] = get_resp_header(response, "vary")

      refute String.contains?(vary_header, "mvt-some_experiment")
    end
  end

  describe "when on test enironment and lambda returns expected vary header" do
    setup do
      set_environment("test")
      set_mvt_slot([%{"header" => "bbc-mvt-1", "key" => "button_colour"}])
    end

    test "the response will vary on the mapped numeric mvt header" do
      expect_lambda_call(times_called: 1, vary_response: "mvt-button_colour")

      response =
        conn(:get, "/mvt")
        |> put_req_header("bbc-mvt-1", "experiment;button_colour;red")
        |> put_req_header("bbc-mvt-5", "feature;sidebar;false")
        |> Router.call([])

      [vary_header] = get_resp_header(response, "vary")

      assert String.contains?(vary_header, "bbc-mvt-1")
      refute String.contains?(vary_header, "bbc-mvt-5")
    end

    test "the response will vary on override headers" do
      expect_lambda_call(times_called: 1, vary_response: "mvt-some_experiment")

      response =
        conn(:get, "/mvt")
        |> put_req_header("mvt-some_experiment", "experiment;some_value")
        |> Router.call([])

      [vary_header] = get_resp_header(response, "vary")

      assert String.contains?(vary_header, "mvt-some_experiment")
    end
  end

  describe "when on test environment and lambda returns vary header which doesn't match mvt header" do
    setup do
      set_environment("test")
      set_mvt_slot([%{"header" => "bbc-mvt-1", "key" => "button_colour"}])
    end

    test "the response will not vary on the mapped numeric mvt header" do
      expect_lambda_call(times_called: 1, vary_response: "mvt-wrong_response")

      response =
        conn(:get, "/mvt")
        |> put_req_header("bbc-mvt-1", "experiment;button_colour;red")
        |> put_req_header("bbc-mvt-5", "feature;sidebar;false")
        |> Router.call([])

      [vary_header] = get_resp_header(response, "vary")

      refute String.contains?(vary_header, "bbc-mvt-1")
      refute String.contains?(vary_header, "bbc-mvt-5")
    end

    test "the response will not vary on override mvt headers" do
      expect_lambda_call(times_called: 1, vary_response: "mvt-wrong_response")

      response =
        conn(:get, "/mvt")
        |> put_req_header("mvt-some_experiment", "experiment;some_value")
        |> Router.call([])

      [vary_header] = get_resp_header(response, "vary")

      refute String.contains?(vary_header, "mvt-some_experiment")
    end
  end
end
