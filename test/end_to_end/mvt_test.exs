defmodule EndToEnd.MvtTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox
  import Test.Support.Helper, only: [set_environment: 1, build_https_request_uri: 1]

  alias BelfrageWeb.Router
  alias Belfrage.RouteState
  alias Belfrage.Mvt

  @moduletag :end_to_end

  defp expect_lambda_call(opts) do
    %{times_called: times_called, expected_headers: expected_headers, vary_response: vary_response, max_age: max_age} =
      Enum.into(opts, %{times_called: 1, expected_headers: %{}, vary_response: "", max_age: 30})

    Belfrage.Clients.LambdaMock
    |> expect(:call, times_called, fn _lambda_name, _role_arn, %{headers: actual_headers}, _opts ->
      for {expected_key, expected_value} <- expected_headers do
        assert actual_headers[expected_key] == expected_value
      end

      {:ok, lambda_response(vary_response: vary_response, max_age: max_age)}
    end)
  end

  defp lambda_response(opts) do
    %{vary_response: vary_response, max_age: max_age} = Enum.into(opts, %{vary_response: "", max_age: 30})

    %{
      "headers" => %{
        "cache-control" => "public, max-age=#{max_age}",
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
    pid = start_supervised!({RouteState, "SomeMvtRouteState"})
    {:ok, route_state_pid: pid}
  end

  describe "when on live environment and lambda returns expected vary header" do
    setup do
      set_environment("live")
      set_mvt_slot(%{"bbc-mvt-1" => "button_colour"})
    end

    test "the response will vary on the mapped numeric mvt header" do
      expect_lambda_call(times_called: 1, vary_response: "mvt-button_colour,mvt-sidebar")

      response =
        conn(:get, build_https_request_uri("/mvt"))
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
        conn(:get, build_https_request_uri("/mvt"))
        |> put_req_header("mvt-some_experiment", "experiment;some_value")
        |> Router.call([])

      [vary_header] = get_resp_header(response, "vary")

      refute String.contains?(vary_header, "mvt-some_experiment")
    end
  end

  describe "when on live environment and lambda returns vary header which doesn't match any mvt header" do
    setup do
      set_environment("live")
      set_mvt_slot(%{"bbc-mvt-1" => "button_colour"})
    end

    test "the response will not vary on the mapped numeric mvt header" do
      expect_lambda_call(times_called: 1, vary_response: "mvt-wrong_response")

      response =
        conn(:get, build_https_request_uri("/mvt"))
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
        conn(:get, build_https_request_uri("/mvt"))
        |> put_req_header("mvt-some_experiment", "experiment;some_value")
        |> Router.call([])

      [vary_header] = get_resp_header(response, "vary")

      refute String.contains?(vary_header, "mvt-some_experiment")
    end
  end

  describe "when on test enironment and lambda returns expected vary header" do
    setup do
      set_environment("test")
      set_mvt_slot(%{"bbc-mvt-1" => "button_colour"})
    end

    test "the response will vary on the mapped numeric mvt header" do
      expect_lambda_call(times_called: 1, vary_response: "mvt-button_colour")

      response =
        conn(:get, build_https_request_uri("/mvt"))
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
        conn(:get, build_https_request_uri("/mvt"))
        |> put_req_header("mvt-some_experiment", "experiment;some_value")
        |> Router.call([])

      [vary_header] = get_resp_header(response, "vary")

      assert String.contains?(vary_header, "mvt-some_experiment")
    end
  end

  describe "when on test environment and lambda returns vary header which doesn't match mvt header" do
    setup do
      set_environment("test")
      set_mvt_slot(%{"bbc-mvt-1" => "button_colour"})
    end

    test "the response will not vary on the mapped numeric mvt header" do
      expect_lambda_call(times_called: 1, vary_response: "mvt-wrong_response")

      response =
        conn(:get, build_https_request_uri("/mvt"))
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
        conn(:get, build_https_request_uri("/mvt"))
        |> put_req_header("mvt-some_experiment", "experiment;some_value")
        |> Router.call([])

      [vary_header] = get_resp_header(response, "vary")

      refute String.contains?(vary_header, "mvt-some_experiment")
    end
  end

  test "keys for cached responses only vary on previously seen MVT vary headers in response" do
    set_mvt_slot(%{"bbc-mvt-1" => "button_colour"})

    expect_lambda_call(times_called: 1, vary_response: "mvt-button_colour")

    conn(:get, build_https_request_uri("/mvt"))
    |> put_req_header("bbc-mvt-1", "experiment;button_colour;red")
    |> Router.call([])

    assert cached_responses() == 0

    expect_lambda_call(times_called: 1, vary_response: "mvt-button_colour")

    conn(:get, build_https_request_uri("/mvt"))
    |> put_req_header("bbc-mvt-1", "experiment;button_colour;red")
    |> Router.call([])

    assert cached_responses() == 1

    # Check that the lambda is not called and as such a cached
    # response is fetched, as the request signature will be the
    # same in the third request - even though a new MVT feature
    # is present in the request headers.
    Belfrage.Clients.LambdaMock
    |> expect(:call, 0, fn _lambda_name, _role_arn, %{headers: _headers}, _opts ->
      flunk("Should never be called.")
    end)

    response =
      conn(:get, build_https_request_uri("/mvt"))
      |> put_req_header("bbc-mvt-1", "experiment;button_colour;red")
      |> put_req_header("bbc-mvt-2", "feature;sidebar;false")
      |> Router.call([])

    assert cached_responses() == 1

    [vary_header] = get_resp_header(response, "vary")
    assert String.contains?(vary_header, "bbc-mvt-1")
    refute String.contains?(vary_header, "bbc-mvt-2")
    assert 200 == response.status
  end

  test "MVT header from origin is set in vary header if in slots but not request headers" do
    set_mvt_slot(%{"bbc-mvt-2" => "button_colour"})

    expect_lambda_call(times_called: 1, vary_response: "mvt-button_colour")

    response =
      conn(:get, build_https_request_uri("/mvt"))
      |> Router.call([])

    [vary_header] = get_resp_header(response, "vary")
    assert String.contains?(vary_header, "bbc-mvt-2")
    assert 200 == response.status
  end

  test "MVT header from origin is set in vary header if in slots and request headers" do
    expect_lambda_call(times_called: 1, vary_response: "mvt-button_colour")

    response =
      conn(:get, build_https_request_uri("/mvt"))
      |> put_req_header("bbc-mvt-2", "experiment;button_colour;red")
      |> Router.call([])

    [vary_header] = get_resp_header(response, "vary")
    refute String.contains?(vary_header, "bbc-mvt-2")
    assert 200 == response.status
  end

  test "Response is not cached if all MVT headers in response vary are not in :mvt_seen", %{
    route_state_pid: pid
  } do
    :sys.replace_state(pid, fn state ->
      Map.put(state, :mvt_seen, %{"mvt-button_colour" => DateTime.utc_now()})
    end)

    set_mvt_slot(%{"bbc-mvt-2" => "button_colour"})

    expect_lambda_call(
      times_called: 1,
      vary_response: "mvt-box_colour_change,something,mvt-banner_colour,something_else"
    )

    response =
      conn(:get, build_https_request_uri("/mvt"))
      |> put_req_header("bbc-mvt-2", "experiment;button_colour;red")
      |> Router.call([])

    assert cached_responses() == 0

    [cache_control] = get_resp_header(response, "cache-control")
    assert String.contains?(cache_control, "public")

    assert 200 == response.status
  end

  test "Response is not cached if there are MVT headers in response vary but nothing in :mvt_seen" do
    set_mvt_slot(%{"bbc-mvt-2" => "button_colour"})

    expect_lambda_call(
      times_called: 1,
      vary_response: "mvt-box_colour_change,something,mvt-banner_colour,something_else"
    )

    response =
      conn(:get, build_https_request_uri("/mvt"))
      |> put_req_header("bbc-mvt-2", "experiment;button_colour;red")
      |> Router.call([])

    assert cached_responses() == 0

    [cache_control] = get_resp_header(response, "cache-control")
    assert String.contains?(cache_control, "public")

    assert 200 == response.status
  end

  defp cached_responses() do
    :cache
    |> :ets.tab2list()
    |> Enum.count()
  end
end
