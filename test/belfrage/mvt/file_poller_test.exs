defmodule Belfrage.Mvt.FilePollerTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox
  import Test.Support.Helper, only: [wait_for: 1]

  alias Belfrage.Mvt.{FilePoller, Headers}
  alias Belfrage.Clients.{HTTP, HTTPMock}

  @mvt_json_payload File.read!("test/support/fixtures/mvt_slot_headers.json")

  test "fetches and updates Mvt Headers from S3" do
    assert Headers.get() == []

    expect(HTTPMock, :execute, fn _, _origin ->
      {:ok, %HTTP.Response{status_code: 200, body: @mvt_json_payload}}
    end)

    start_supervised!({FilePoller, interval: 0, name: :test_mvt_file_poller})
    project_headers = Jason.decode!(@mvt_json_payload)["projects"]

    wait_for(fn -> Headers.get() == project_headers end)
  end
end
