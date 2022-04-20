defmodule Belfrage.Authentication.BBCID.AvailabilityPollerTest do
  # Can't be async because it updates the state of
  # Belfrage.Authentication.BBCID which is a global resource
  use ExUnit.Case
  use Test.Support.Helper, :mox
  import Test.Support.Helper, only: [wait_for: 1]

  alias Belfrage.Authentication.BBCID
  alias Belfrage.Authentication.BBCID.AvailabilityPoller
  alias Belfrage.Clients.{HTTP, HTTPMock}

  test "fetches and updates the availability of BBC ID" do
    assert BBCID.available?()

    expect(HTTPMock, :execute, fn _, _origin ->
      payload = "{\"id-availability\": \"RED\"}"
      {:ok, %HTTP.Response{status_code: 200, body: payload}}
    end)

    start_supervised!({AvailabilityPoller, interval: 0, name: :test_bbc_id_availability_poller})
    wait_for(fn -> not BBCID.available?() end)

    expect(HTTPMock, :execute, fn _, _origin ->
      payload = "{\"id-availability\": \"GREEN\"}"
      {:ok, %HTTP.Response{status_code: 200, body: payload}}
    end)

    wait_for(fn -> BBCID.available?() end)
  end
end
