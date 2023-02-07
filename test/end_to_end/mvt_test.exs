defmodule EndToEnd.MvtTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox
  import Test.Support.Helper, only: [set_environment: 1]

  alias BelfrageWeb.Router
  alias Belfrage.RouteState
  alias Belfrage.Mvt

  alias Belfrage.Clients.HTTP

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

  defp expect_http_execute(opts) do
    times_called = Keyword.get(opts, :times_called, 1)
    expected_headers = Keyword.get(opts, :expected_headers, %{})
    refute_headers = Keyword.get(opts, :refute_headers, [])

    Belfrage.Clients.HTTPMock
    |> expect(:execute, times_called, fn %HTTP.Request{headers: actual_headers}, _private ->
      for {expected_key, expected_value} <- expected_headers do
        assert actual_headers[expected_key] == expected_value
      end

      for header_key <- refute_headers do
        refute actual_headers[header_key]
      end

      http_response(opts)
    end)
  end

  defp http_response(opts) do
    vary_response = Keyword.get(opts, :vary_response, "")
    max_age = Keyword.get(opts, :max_age, 30)

    {
      :ok,
      %HTTP.Response{
        status_code: 200,
        body: "<p>Hello There</p>",
        headers: %{
          "content-type" => "text/html",
          "vary" => vary_response,
          "cache-control" => "public, max-age=#{max_age}"
        }
      }
    }
  end

  defp set_mvt_slot(slots, opts \\ []) do
    project_id = Keyword.get(opts, :project_id, "1")

    Mvt.Slots.set(%{project_id => slots})
    on_exit(fn -> Mvt.Slots.set(%{}) end)
    :ok
  end

  defp cached_responses() do
    :cache
    |> :ets.tab2list()
    |> Enum.count()
  end

  setup do
    :ets.delete_all_objects(:cache)

    %{
      webcore_route_state_pid: start_supervised!({RouteState, "SomeMvtRouteState.Webcore"}, id: :SomeMvtRouteState),
      simorgh_route_state_pid:
        start_supervised!({RouteState, "SomeSimorghRouteSpec.Simorgh"}, id: :SomeSimorghRouteSpec)
    }
  end

  describe "when on live environment and lambda returns expected vary header" do
    setup do
      set_environment("live")
      set_mvt_slot(%{"bbc-mvt-1" => "button_colour"})
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
      assert String.contains?(vary_header, "bbc-mvt-complete")
      refute String.contains?(vary_header, "bbc-mvt-5")
    end

    test "the response will not vary on override mvt headers" do
      expect_lambda_call(times_called: 1, vary_response: "mvt-some_experiment")

      response =
        conn(:get, "/mvt")
        |> put_req_header("mvt-some_experiment", "experiment;some_value")
        |> Router.call([])

      [vary_header] = get_resp_header(response, "vary")

      assert String.contains?(vary_header, "bbc-mvt-complete")
      refute String.contains?(vary_header, "mvt-some_experiment")
    end

    test "the response will not differ on override header values" do
      expect_lambda_call(times_called: 2, vary_response: "mvt-some_experiment")

      response =
        conn(:get, "/mvt")
        |> put_req_header("mvt-some_experiment", "experiment;some_value_a")
        |> Router.call([])

      [request_id_one] = get_resp_header(response, "bsig")

      response =
        conn(:get, "/mvt")
        |> put_req_header("mvt-some_experiment", "experiment;some_value_b")
        |> Router.call([])

      [request_id_two] = get_resp_header(response, "bsig")

      assert request_id_one == request_id_two
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
        conn(:get, "/mvt")
        |> put_req_header("bbc-mvt-1", "experiment;button_colour;red")
        |> put_req_header("bbc-mvt-5", "feature;sidebar;false")
        |> Router.call([])

      [vary_header] = get_resp_header(response, "vary")

      refute String.contains?(vary_header, "bbc-mvt-1")
      refute String.contains?(vary_header, "bbc-mvt-5")
      refute String.contains?(vary_header, "mvt-wrong_response")
      assert String.contains?(vary_header, "bbc-mvt-complete")
    end

    test "the response will not vary on override mvt headers" do
      expect_lambda_call(times_called: 1, vary_response: "mvt-some_experiment")

      response =
        conn(:get, "/mvt")
        |> put_req_header("mvt-some_experiment", "experiment;some_value")
        |> Router.call([])

      [vary_header] = get_resp_header(response, "vary")

      refute String.contains?(vary_header, "mvt-some_experiment")
      assert String.contains?(vary_header, "bbc-mvt-complete")
    end
  end

  describe "when on test environment and lambda returns expected vary header" do
    setup do
      set_environment("test")
      set_mvt_slot(%{"bbc-mvt-1" => "button_colour"})
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
      assert String.contains?(vary_header, "bbc-mvt-complete")
    end

    test "the response will differ on mapped mvt header values" do
      expect_lambda_call(times_called: 2, vary_response: "mvt-button_colour")

      response =
        conn(:get, "/mvt")
        |> put_req_header("bbc-mvt-1", "experiment;button_colour;green")
        |> Router.call([])

      [request_id_one] = get_resp_header(response, "bsig")

      response =
        conn(:get, "/mvt")
        |> put_req_header("bbc-mvt-1", "experiment;button_colour;blue")
        |> Router.call([])

      [request_id_two] = get_resp_header(response, "bsig")

      refute request_id_one == request_id_two
    end

    test "the response will vary on override headers" do
      expect_lambda_call(times_called: 1, vary_response: "mvt-some_experiment")

      response =
        conn(:get, "/mvt")
        |> put_req_header("mvt-some_experiment", "experiment;some_value")
        |> Router.call([])

      [vary_header] = get_resp_header(response, "vary")

      assert String.contains?(vary_header, "mvt-some_experiment")
      assert String.contains?(vary_header, "bbc-mvt-complete")
    end

    test "the response will differ on override header values" do
      expect_lambda_call(times_called: 2, vary_response: "mvt-some_experiment")

      response =
        conn(:get, "/mvt")
        |> put_req_header("mvt-some_experiment", "experiment;some_value_a")
        |> Router.call([])

      [request_id_one] = get_resp_header(response, "bsig")

      response =
        conn(:get, "/mvt")
        |> put_req_header("mvt-some_experiment", "experiment;some_value_b")
        |> Router.call([])

      [request_id_two] = get_resp_header(response, "bsig")

      refute request_id_one == request_id_two
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
        conn(:get, "/mvt")
        |> put_req_header("bbc-mvt-1", "experiment;button_colour;red")
        |> put_req_header("bbc-mvt-5", "feature;sidebar;false")
        |> Router.call([])

      [vary_header] = get_resp_header(response, "vary")

      refute String.contains?(vary_header, "bbc-mvt-1")
      refute String.contains?(vary_header, "bbc-mvt-5")
      assert String.contains?(vary_header, "bbc-mvt-complete")
    end

    test "the response will not vary on override mvt headers" do
      expect_lambda_call(times_called: 1, vary_response: "mvt-wrong_response")

      response =
        conn(:get, "/mvt")
        |> put_req_header("mvt-some_experiment", "experiment;some_value")
        |> Router.call([])

      [vary_header] = get_resp_header(response, "vary")

      refute String.contains?(vary_header, "mvt-some_experiment")
      assert String.contains?(vary_header, "bbc-mvt-complete")
    end
  end

  test "keys for cached responses only vary on previously seen MVT vary headers in response" do
    set_mvt_slot(%{"bbc-mvt-1" => "button_colour"})

    expect_lambda_call(times_called: 1, vary_response: "mvt-button_colour")

    response =
      conn(:get, "/mvt")
      |> put_req_header("bbc-mvt-1", "experiment;button_colour;red")
      |> Router.call([])

    [vary_header] = get_resp_header(response, "vary")
    assert String.contains?(vary_header, "bbc-mvt-1")
    assert String.contains?(vary_header, "bbc-mvt-complete")

    assert cached_responses() == 0

    expect_lambda_call(times_called: 1, vary_response: "mvt-button_colour")

    response =
      conn(:get, "/mvt")
      |> put_req_header("bbc-mvt-1", "experiment;button_colour;red")
      |> Router.call([])

    [vary_header] = get_resp_header(response, "vary")
    assert String.contains?(vary_header, "bbc-mvt-1")
    assert String.contains?(vary_header, "bbc-mvt-complete")

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
      conn(:get, "/mvt")
      |> put_req_header("bbc-mvt-1", "experiment;button_colour;red")
      |> put_req_header("bbc-mvt-2", "feature;sidebar;false")
      |> Router.call([])

    assert cached_responses() == 1

    [vary_header] = get_resp_header(response, "vary")
    assert String.contains?(vary_header, "bbc-mvt-1")
    refute String.contains?(vary_header, "bbc-mvt-2")
    assert String.contains?(vary_header, "bbc-mvt-complete")
    assert 200 == response.status
  end

  test "MVT header from origin is set in vary header if in slots but not request headers" do
    set_mvt_slot(%{"bbc-mvt-2" => "button_colour"})

    expect_lambda_call(times_called: 1, vary_response: "mvt-button_colour")

    response =
      conn(:get, "/mvt")
      |> Router.call([])

    [vary_header] = get_resp_header(response, "vary")
    assert String.contains?(vary_header, "bbc-mvt-2")
    assert 200 == response.status
  end

  test "MVT header from origin is set in vary header if in slots and request headers" do
    expect_lambda_call(times_called: 1, vary_response: "mvt-button_colour")

    response =
      conn(:get, "/mvt")
      |> put_req_header("bbc-mvt-2", "experiment;button_colour;red")
      |> Router.call([])

    [vary_header] = get_resp_header(response, "vary")
    refute String.contains?(vary_header, "bbc-mvt-2")
    assert 200 == response.status
  end

  test "the response will differ on mapped mvt header values" do
    expect_lambda_call(times_called: 2, vary_response: "mvt-button_colour")

    response =
      conn(:get, "/mvt")
      |> put_req_header("bbc-mvt-1", "experiment;button_colour;green")
      |> Router.call([])

    [request_id_one] = get_resp_header(response, "bsig")

    response =
      conn(:get, "/mvt")
      |> put_req_header("bbc-mvt-1", "experiment;button_colour;blue")
      |> Router.call([])

    [request_id_two] = get_resp_header(response, "bsig")

    refute request_id_one == request_id_two
  end

  test "Response is not cached if all MVT headers in response vary are not in :mvt_seen", %{
    webcore_route_state_pid: pid
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
      conn(:get, "/mvt")
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
      conn(:get, "/mvt")
      |> put_req_header("bbc-mvt-2", "experiment;button_colour;red")
      |> Router.call([])

    assert cached_responses() == 0

    [cache_control] = get_resp_header(response, "cache-control")
    assert String.contains?(cache_control, "public")

    assert 200 == response.status
  end

  describe "calling mvt enabled http endpoint" do
    setup do
      set_mvt_slot(%{"bbc-mvt-1" => "button_colour"}, project_id: "2")
    end

    test "will not leak original mvt headers (bbc-mvt-{i}) to the endpoint" do
      set_environment("live")

      expect_http_execute(
        times_called: 1,
        vary_response: "mvt-button_colour",
        # these header names should not exist in the request as they should be
        # removed by Mvt.Headers.remove_original_headers/1
        refute_headers: ["bbc-mvt-1", "bbc-mvt-5"],
        expected_headers: %{"mvt-button_colour" => "experiment;red"}
        # we only expect this header as 'mvt-sidebar' should be filtered as its
        # not in the slot.
      )

      conn(:get, "/ws-mvt")
      |> put_req_header("bbc-mvt-1", "experiment;button_colour;red")
      |> put_req_header("bbc-mvt-5", "feature;sidebar;false")
      |> Router.call([])
    end

    test "on live, mvt headers but not override headers are in the request headers" do
      set_environment("live")

      expect_http_execute(
        times_called: 1,
        refute_headers: ["mvt-some_experiment"],
        expected_headers: %{"mvt-button_colour" => "experiment;red"}
      )

      conn(:get, "/ws-mvt")
      |> put_req_header("bbc-mvt-1", "experiment;button_colour;red")
      |> put_req_header("mvt-some_experiment", "experiment;some_value")
      |> Router.call([])
    end

    test "on test, mvt headers and override headers are in the request headers" do
      set_environment("test")

      expect_http_execute(
        times_called: 1,
        refute_headers: ["bbc-mvt-1"],
        expected_headers: %{
          "mvt-button_colour" => "experiment;red",
          "mvt-some_experiment" => "experiment;some_value"
        }
      )

      conn(:get, "/ws-mvt")
      |> put_req_header("bbc-mvt-1", "experiment;button_colour;red")
      |> put_req_header("mvt-some_experiment", "experiment;some_value")
      |> Router.call([])
    end

    test "on test and live 'bbc-mvt-complete' is removed from the raw headers" do
      expect_http_execute(
        times_called: 1,
        refute_headers: ["bbc-mvt-complete"]
      )

      conn(:get, "/ws-mvt")
      |> put_req_header("bbc-mvt-complete", "1")
      |> Router.call([])
    end

    test "on live, will vary on mapped mvt headers but will not vary on override headers" do
      set_environment("live")

      expect_http_execute(
        times_called: 1,
        refute_headers: ["bbc-mvt-1", "bbc-mvt-5"],
        expected_headers: %{"mvt-button_colour" => "experiment;red"},
        vary_response: "mvt-button_colour,mvt-sidebar"
      )

      response =
        conn(:get, "/ws-mvt")
        |> put_req_header("bbc-mvt-1", "experiment;button_colour;red")
        |> put_req_header("bbc-mvt-5", "feature;sidebar;false")
        |> put_req_header("mvt-some_experiment", "experiment;some_value")
        |> Router.call([])

      [vary_header] = get_resp_header(response, "vary")

      assert String.contains?(vary_header, "bbc-mvt-1")
      refute String.contains?(vary_header, "bbc-mvt-5")
      refute String.contains?(vary_header, "mvt-some_experiment")
    end

    test "on test, will vary on mapped mvt headers and on override headers" do
      set_environment("test")

      expect_http_execute(
        times_called: 1,
        refute_headers: ["bbc-mvt-1", "bbc-mvt-5"],
        expected_headers: %{"mvt-button_colour" => "experiment;red"},
        vary_response: "mvt-button_colour,mvt-sidebar,mvt-some_experiment"
      )

      response =
        conn(:get, "/ws-mvt")
        |> put_req_header("bbc-mvt-1", "experiment;button_colour;red")
        |> put_req_header("bbc-mvt-5", "feature;sidebar;false")
        |> put_req_header("mvt-some_experiment", "experiment;some_value")
        |> Router.call([])

      [vary_header] = get_resp_header(response, "vary")

      assert String.contains?(vary_header, "bbc-mvt-1")
      refute String.contains?(vary_header, "bbc-mvt-5")
      assert String.contains?(vary_header, "mvt-some_experiment")
    end

    test "on test and live if mvt_project_id is set on the route 'bbc-mvt-complete' will be in the vary header" do
      expect_http_execute(
        times_called: 1,
        refute_headers: ["bbc-mvt-1", "bbc-mvt-complete"],
        vary_response: "mvt-button_colour"
      )

      response =
        conn(:get, "/ws-mvt")
        |> put_req_header("bbc-mvt-1", "experiment;button_colour;red")
        |> Router.call([])

      [vary_header] = get_resp_header(response, "vary")

      assert String.contains?(vary_header, "bbc-mvt-1")
      assert String.contains?(vary_header, "bbc-mvt-complete")
    end
  end
end
