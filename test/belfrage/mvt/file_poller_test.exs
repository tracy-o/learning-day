defmodule Belfrage.Mvt.FilePollerTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox
  import Test.Support.Helper, only: [wait_for: 1]

  alias Belfrage.Mvt.{FilePoller, Slots}
  alias Belfrage.Clients.{HTTP, HTTPMock}

  @mvt_json_payload File.read!("test/support/fixtures/mvt_slot_headers.json")

  test "fetches and updates Mvt Slots from S3" do
    Slots.set(Belfrage.Mvt.Slots, %{})

    assert Slots.available() == %{}

    expect(HTTPMock, :execute, fn _, _origin ->
      {:ok, %HTTP.Response{status_code: 200, body: @mvt_json_payload}}
    end)

    start_supervised!({FilePoller, interval: 0, name: :test_mvt_file_poller})
    project_headers = Jason.decode!(@mvt_json_payload)["projects"]

    wait_for(fn -> Slots.available() == project_headers end)
  end

  test "if there is an error fetching the file it will not set the file content in the agent" do
    Slots.set(Belfrage.Mvt.Slots, %{})
    assert Slots.available() == %{}

    expect(HTTPMock, :execute, fn _, _origin ->
      {:ok, %HTTP.Response{status_code: 500, body: "{foo: \"bar\"}"}}
    end)

    start_supervised!({FilePoller, interval: 0, name: :test_mvt_file_poller})

    Process.sleep(10)
    assert Slots.available() == %{}
  end

  test "if the file is malformed it will not set the file content in the agent" do
    Slots.set(Belfrage.Mvt.Slots, %{})
    assert Slots.available() == %{}

    expect(HTTPMock, :execute, fn _, _origin ->
      {:ok, %HTTP.Response{status_code: 500, body: "malformed json"}}
    end)

    start_supervised!({FilePoller, interval: 0, name: :test_mvt_file_poller})

    Process.sleep(10)
    assert Slots.available() == %{}
  end
end
