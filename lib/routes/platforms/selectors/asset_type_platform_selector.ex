defmodule Routes.Platforms.Selectors.AssetTypePlatformSelector do
  alias Belfrage.Envelope.Request
  alias Belfrage.Clients.HTTP
  alias Routes.Platforms.Selectors.Fetchers.AresData

  require Logger

  @behaviour Belfrage.Behaviours.Selector

  @webcore_asset_types ["MAP", "CSP", "PGL", "STY"]

  @doc """
  Makes a GET request to the FABL module: ares-data.
  If a response with a 200 status code and a payload that
  contains a Webcore asset type is returned, then the following
  tuple is returned:

    {:ok, "Webcore"}

  If a response with a 200 status code and a payload that
  does not contain a Webcore asset type is returned, then the
  following tuple is returned:

    {:ok, "MozartNews"}

  If a response with a 404 status code is returned, then the
  following tuple is returned:

    {:ok, "MozartNews"}

  otherwise an error tuple is returned:

    {:error, status_code}
  """
  @impl Belfrage.Behaviours.Selector
  def call(request = %Request{}) do
    case AresData.fetch_metadata(request.path) do
      {:ok, asset_type} ->
        select_platform(asset_type)

      {:error, %HTTP.Response{status_code: 404}} ->
        {:ok, "MozartNews"}

      {_, reason} ->
        Logger.log(
          :error,
          "#{__MODULE__} could not select platform: %{path: #{request.path}, reason: #{inspect(reason)}}"
        )

        {:error, 500}
    end
  end

  defp select_platform(asset_type) do
    if asset_type in @webcore_asset_types do
      {:ok, "Webcore"}
    else
      {:ok, "MozartNews"}
    end
  end
end
