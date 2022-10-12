defmodule Routes.Platforms.Selectors.Fetchers.AresData do
  alias Belfrage.{Helpers.QueryParams, Clients.HTTP}

  @http_client Application.compile_env(:belfrage, :http_client, HTTP)

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
    origin = Application.get_env(:belfrage, :fabl_endpoint)

    @http_client.execute(
      %HTTP.Request{
        method: :get,
        url: origin <> "/module/ares-data" <> QueryParams.encode(%{path: path}),
        timeout: 1_000
      },
      :Fabl
    )
  end
end