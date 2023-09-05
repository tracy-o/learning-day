defmodule Belfrage.Authentication.BBCID.AvailabilityPoller do
  @moduledoc """
  This process periodically gets the status of BBC ID services from the IDCTA
  config endpoint and updates the state of `Belfrage.Authentication.BBCID`
  process.
  """

  require Logger

  use Belfrage.Poller, interval: Application.compile_env!(:belfrage, :poller_intervals)[:bbc_id_availability]

  alias Belfrage.Authentication.BBCID

  @client Application.compile_env(:belfrage, :json_client)
  @http_pool :AccountAuthentication

  @impl true
  def poll() do
    case @client.get(idcta_uri(), @http_pool, name: "idcta_config") do
      {:ok, config} ->
        BBCID.set_opts(make_config_map(config))

      error ->
        Logger.log(:error, "IDCTA config cannot be fetched, reason: #{inspect(error)}")
        BBCID.set_opts(make_config_map(%{}))
    end
  end

  defp make_config_map(config) do
    %{
      id_availability: state_to_bool(Map.get(config, "id-availability", "GREEN")),
      foryou_flagpole: state_to_bool(Map.get(config, "foryou-flagpole", "RED")),
      foryou_access_chance: access_chance_to_int(Map.get(config, "foryou-access-chance", 0)),
      foryou_allowlist: ensure_list(Map.get(config, "forYouAllowlist", []))
    }
  end

  defp state_to_bool("GREEN"), do: true
  defp state_to_bool(_state), do: false

  defp ensure_list(list) when is_list(list), do: list
  defp ensure_list(_other), do: []

  defp access_chance_to_int(int) when is_integer(int), do: int

  defp access_chance_to_int(str) when is_binary(str) do
    case Integer.parse(str) do
      {n, ""} -> n
      _ -> 0
    end
  end

  defp access_chance_to_int(_other), do: 0

  defp idcta_uri, do: Application.get_env(:belfrage, :authentication)["idcta_config_uri"]
end
