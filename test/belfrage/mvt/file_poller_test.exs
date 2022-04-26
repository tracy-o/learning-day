defmodule Belfrage.Mvt.FilePollerTest do
  use ExUnit.Case, async: true
  use Test.Support.Helper, :mox
  import Test.Support.Helper, only: [wait_for: 1]

  alias Belfrage.Mvt.{FilePoller, Headers}
  alias Belfrage.Clients.{HTTP, HTTPMock}

  test "fetches and updates JWK keys from the API" do
    assert Headers.get() == []

    expect(HTTPMock, :execute, fn _, _origin ->
      {:ok, %HTTP.Response{status_code: 200, body: mvt_json_payload}}
    end)

    start_supervised!({FilePoller, interval: 0, name: :test_mvt_file_poller})
    wait_for(fn -> Headers.get() == {:ok, Jason.decode(mvt_json_payload())} end)
  end

  defp mvt_json_payload do
    "{ \"1\": [ { \"key\": \"box_colour_change\", \"header\": \"bbc-mvt-1\" } ], \"projects\": { \"1\": [ { \"key\": \"test_feature_1_test\", \"header\": \"bbc-mvt-1\" }, { \"key\": \"test_experiment_1\", \"header\": \"bbc-mvt-2\" }, { \"key\": \"test_experiment_2\", \"header\": \"bbc-mvt-3\" } ], \"2\": [ { \"key\": \"test_feature_1_test\", \"header\": \"bbc-mvt-1\" }, { \"key\": \"test_experiment_1\", \"header\": \"bbc-mvt-2\" }, { \"key\": \"test_experiment_2\", \"header\": \"bbc-mvt-3\" } ] } }"
  end
end
