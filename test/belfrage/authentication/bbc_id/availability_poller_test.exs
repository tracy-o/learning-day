defmodule Belfrage.Authentication.BBCID.AvailabilityPollerTest do
  # Can't be async because it updates the state of
  # Belfrage.Authentication.BBCID which is a global resource
  use ExUnit.Case
  use Test.Support.Helper, :mox
  import Test.Support.Helper, only: [wait_for: 1]

  alias Belfrage.Authentication.BBCID
  alias Belfrage.Authentication.BBCID.AvailabilityPoller
  alias Belfrage.Clients.{HTTP, HTTPMock}

  test "fetches and updates IDCTA config options" do
    start_supervised!({AvailabilityPoller, interval: 0, name: :test_bbc_id_availability_poller})

    # Ensure that fetching IDCTA config updates config opts
    mock_idcta_config_resp(200, %{
      "id-availability" => "RED",
      "foryou-flagpole" => "GREEN",
      "foryou-access-chance" => "1",
      "forYouAllowlist" => ["some-id"]
    })

    wait_for(fn ->
      BBCID.get_opts() == %{
        id_availability: false,
        foryou_flagpole: true,
        foryou_access_chance: 1,
        foryou_allowlist: ["some-id"]
      }
    end)

    # Ensure that not fetching IDCTA config will reset config opts to default values
    mock_idcta_config_resp(500, "Internal Server Error")

    wait_for(fn ->
      BBCID.get_opts() == %{
        id_availability: true,
        foryou_flagpole: false,
        foryou_access_chance: 0,
        foryou_allowlist: []
      }
    end)

    # Ensure that invalid IDCTA config opts will update config opts
    mock_idcta_config_resp(200, %{
      "id-availability" => "INVALID_STATE",
      "foryou-flagpole" => "INVALID_STATE",
      "foryou-access-chance" => "invalid-int-value",
      "forYouAllowlist" => "invalid-list_value"
    })

    wait_for(fn ->
      BBCID.get_opts() == %{
        id_availability: false,
        foryou_flagpole: false,
        foryou_access_chance: 0,
        foryou_allowlist: []
      }
    end)

    # Ensure that missing IDCTA config opts will reset config opts to default values
    mock_idcta_config_resp(200, %{})

    wait_for(fn ->
      BBCID.get_opts() == %{
        id_availability: true,
        foryou_flagpole: false,
        foryou_access_chance: 0,
        foryou_allowlist: []
      }
    end)
  end

  defp mock_idcta_config_resp(status, payload) do
    expect(HTTPMock, :execute, fn _, _origin ->
      {:ok, %HTTP.Response{status_code: status, body: Json.encode!(payload)}}
    end)
  end
end
