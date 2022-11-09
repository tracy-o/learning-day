defmodule Routes.Platforms.Selectors.AssetTypePlatformSelector do
  alias Belfrage.Struct.Request
  alias Belfrage.Clients.HTTP
  alias Routes.Platforms.Selectors.Fetchers.AresData

  require Logger

  @behaviour Routes.Platforms.Selector

  @webcore_asset_types ["MAP", "CSP", "PGL", "STY"]

  @doc """
  Makes a GET request to the FABL module: ares-data.

  If a response with a:

    * 200 status code
    * JSON payload that contains an 'assetType' and 'section' field

  is present, this function will merge
  struct.private.metadata with the data obtained from Ares:

      %{asset_type: asset_type, section: section}

  and call then_do(rest, struct) with the rest of the pipeline
  and the updated Struct, respectively.

  Otherwise then_do(rest, struct) is called with the rest of
  the pipeline and the original Struct.
  """
  @impl Routes.Platforms.Selector
  def call(request = %Request{}) do
    with {:ok, %HTTP.Response{status_code: 200, body: payload}} <- AresData.fetch_metadata(request.path),
         {:ok, asset_type} <- extract_asset_type(payload) do
      select(asset_type)
    else
      e ->
        error_msg = "#{__MODULE__} could not select platform: %{path: #{request.path}, reason: #{inspect(e)}}"
        Logger.log(:error, error_msg)
        raise error_msg
    end
  end

  defp extract_asset_type(payload) do
    case Json.decode!(payload) do
      %{"data" => %{"assetType" => asset_type, "section" => _section}} -> {:ok, asset_type}
      %{"data" => %{"assetType" => _asset_type}} -> {:error, :no_section}
      _ -> {:error, :no_asset_type}
    end
  end

  defp select(asset_type) do
    if asset_type in @webcore_asset_types do
      Webcore
    else
      MozartNews
    end
  end
end
