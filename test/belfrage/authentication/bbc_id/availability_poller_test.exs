defmodule Belfrage.Authentication.BBCID.AvailabilityPollerTest do
  # Can't be async because it updates the state of
  # Belfrage.Authentication.BBCID which is a global resource
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.Authentication.BBCID
  alias Belfrage.Authentication.BBCID.AvailabilityPoller
  alias Belfrage.Clients.AuthenticationMock, as: AuthenticationClient

  test "fetches and updates the availability of BBC ID" do
    assert BBCID.available?()

    stub_idcta_config({:ok, %{"id-availability" => "RED"}})
    start_supervised!({AvailabilityPoller, interval: 0})
    wait_until(fn -> not BBCID.available?() end)

    stub_idcta_config({:ok, %{"id-availability" => "GREEN"}})
    wait_until(fn -> BBCID.available?() end)
  end

  describe "get_availability/0" do
    test "returns true if status of flagpole in IDCTA config is GREEN" do
      stub_idcta_config({:ok, %{"id-availability" => "GREEN"}})
      assert AvailabilityPoller.get_availability() == {:ok, true}
    end

    test "returns false if status of flagpole in IDCTA config is RED" do
      stub_idcta_config({:ok, %{"id-availability" => "RED"}})
      assert AvailabilityPoller.get_availability() == {:ok, false}
    end

    test "returns error if status of flagpole is not present in IDCTA config" do
      stub_idcta_config({:ok, %{}})
      assert AvailabilityPoller.get_availability() == {:error, :availability_unknown}
    end

    test "returns error if status of flagpole is an unexpected value" do
      stub_idcta_config({:ok, %{"id-availability" => "FOO"}})
      assert AvailabilityPoller.get_availability() == {:error, :availability_unknown}
    end
  end

  defp stub_idcta_config(config) do
    stub(AuthenticationClient, :get_idcta_config, fn -> config end)
  end

  defp wait_until(condition) do
    condition.() || wait_until(condition)
  end
end
