defmodule Belfrage.Transformers.AresData do
  alias Belfrage.{Helpers.QueryParams, Clients.HTTP, Struct}
  use Belfrage.Transformers.Transformer

  @http_client Application.compile_env(:belfrage, :http_client, HTTP)

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
  @impl true
  def call(rest, struct = %Struct{}) do
    with {:ok, %HTTP.Response{status_code: 200, body: payload}} <- execute_request(struct.request.path),
         {:ok, data} <- extract_data(payload) do
      new_metadata = Map.merge(struct.private.metadata, data)
      then_do(rest, Struct.add(struct, :private, %{metadata: new_metadata}))
    else
      _ -> then_do(rest, struct)
    end
  end

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
  defp execute_request(path) do
    origin = Application.get_env(:belfrage, :fabl_endpoint)

    @http_client.execute(
      %HTTP.Request{
        method: :get,
        url: origin <> "/module/ares-data" <> QueryParams.encode(%{path: path})
      },
      :Fabl
    )
  end

  defp extract_data(payload) do
    case Json.decode!(payload) do
      %{"assetType" => asset_type, "section" => section} -> {:ok, %{asset_type: asset_type, section: section}}
      _ -> {:error, :no_asset_type}
    end
  end
end
