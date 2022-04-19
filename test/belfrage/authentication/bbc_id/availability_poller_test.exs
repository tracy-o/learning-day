defmodule Belfrage.Authentication.BBCID.AvailabilityPollerTest do
  # Can't be async because it updates the state of
  # Belfrage.Authentication.BBCID which is a global resource
  use ExUnit.Case
  use Test.Support.Helper, :mox
  import Test.Support.Helper, only: [wait_for: 1]

  alias Belfrage.Authentication.BBCID
  alias Belfrage.Authentication.BBCID.AvailabilityPoller
  alias Belfrage.Clients.JsonMock, as: JsonClient

  test "fetches and updates the availability of BBC ID" do
    assert BBCID.available?()

    stub_idcta_config({:ok, %{"id-availability" => "RED"}})
    start_supervised!({AvailabilityPoller, interval: 0, name: :test_bbc_id_availability_poller})
    wait_for(fn -> not BBCID.available?() end)

    stub_idcta_config({:ok, %{"id-availability" => "GREEN"}})
    wait_for(fn -> BBCID.available?() end)
  end

  defp stub_idcta_config(config) do
    stub(JsonClient, :get, fn _uri, AvailabilityPoller, :AccountAuthentication -> config end)
  end
end
