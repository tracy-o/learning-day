defmodule Belfrage.Clients.HTTP.Request do
  alias Belfrage.Clients.HTTP

  defstruct [
    :method,
    :url,
    :request_id,
    payload: "",
    headers: %{},
    timeout: Application.get_env(:belfrage, :default_timeout)
  ]

  @type t :: %__MODULE__{
          method: :get | :post,
          url: String.t(),
          request_id: String.t(),
          payload: String.t() | map(),
          headers: map(),
          timeout: integer()
        }

  def new(params) do
    %__MODULE__{
      url: params.url,
      method: params.method,
      request_id: Map.get(params, :request_id, nil),
      headers: HTTP.Headers.as_map(params.headers),
      payload: params.payload || "",
      timeout: params.timeout
    }
  end
end
