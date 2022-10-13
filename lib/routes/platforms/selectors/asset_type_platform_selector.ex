defmodule Routes.Platforms.Selectors.AssetTypePlatformSelector do
  alias Belfrage.Struct.Request
  alias Belfrage.Clients.HTTP
  alias Routes.Platforms.Selectors.Fetchers.AresData

  require Logger

  @behaviour Routes.Platforms.Selector

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
  @impl Routes.Platforms.Selector
  def call(request = %Request{}) do
    with {:ok, %HTTP.Response{body: payload, status_code: 200}} <- AresData.fetch_metadata(request.path),
         {:ok, asset_type} <- extract_asset_type(payload) do
      select_platform(asset_type)
    else
      {:ok, %HTTP.Response{status_code: 404}} -> {:ok, "MozartNews"}
    {_, reason} ->
        Logger.log(
          :error,
          "#{__MODULE__} could not select platform: %{path: #{request.path}, reason: #{inspect(reason)}}"
        )

          {:error, 500}
    end
  end

  defp extract_asset_type(payload) do
    case Json.decode!(payload) do
      %{"data" => %{"assetType" => asset_type}} -> {:ok, asset_type}
      _ -> {:error, :no_asset_type}
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
