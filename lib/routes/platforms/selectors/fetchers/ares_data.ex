defmodule Routes.Platforms.Selectors.Fetchers.AresData do
  alias Belfrage.{Helpers.QueryParams, Clients.HTTP}
  alias Belfrage.MetadataCache

  @http_client Application.compile_env(:belfrage, :http_client, HTTP)
  @source "AresData"

  # Makes a GET request to the FABL module ares-data with the module
  # input (page path) provided via the queryparams,
  # as per the documentation [1]:
  #
  #     Module inputs
  #
  #     The inputs to the run function are:
  #
  #     params — any parameters passed by the client in a key-value object.
  #     The query string passed to the FABL API is converted using the NodeJS querystring.parse() function.
  #
  # [1] https://github.com/bbc/fabl-modules/tree/efd29deb89a728eda7a213ebb7eda99af3ce638e#inbox_tray-module-inputs
  def fetch_metadata(path) do
    case MetadataCache.get(@source, path) do
      {:ok, metadata} -> {:ok, metadata}
      {:error, :metadata_not_found} -> fetch_metadata_from_api(path)
    end
  end

  def fetch_metadata_from_api(path) do
    with {:ok, %HTTP.Response{body: payload, status_code: 200}} <- make_request(path),
         {:ok, asset_type} <- extract_asset_type(payload) do
      MetadataCache.put(@source, path, asset_type)
      {:ok, asset_type}
    else
      {:ok, response = %HTTP.Response{}} ->
        {:error, response}
      result = {:error, _reason} ->
        result
    end
  end

  defp make_request(path) do
    origin = Application.get_env(:belfrage, :fabl_endpoint)

    @http_client.execute(
      %HTTP.Request{
        method: :get,
        # This path needs to be updated when the Ares asset identifier module is merged into fabl-modules
        url: origin <> "/preview/module/spike-ares-asset-identifier" <> QueryParams.encode(%{path: path}),
        timeout: 1_000
      },
      :Fabl
    )
  end

  defp extract_asset_type(payload) do
    case Json.decode!(payload) do
      %{"data" => %{"assetType" => asset_type}} -> {:ok, asset_type}
      _ -> {:error, :no_asset_type}
    end
  end
end
