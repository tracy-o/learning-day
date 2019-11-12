defmodule Belfrage.Clients.HTTP.Request do
  alias Belfrage.Clients.HTTP

  defstruct [
    :method,
    :url,
    payload: "",
    headers: %{},
    timeout: Application.get_env(:belfrage, :default_timeout)
  ]

  @type t :: %__MODULE__{
    method: :get | :post,
    url: String.t(),
    payload: String.t() | map(),
    headers: map(),
    timeout: integer()
  }

  def new(params) do
    %__MODULE__{
      url: params.url,
      method: params.method,
      headers: HTTP.Headers.as_map(params.headers),
      payload: params.payload || "",
      timeout: params.timeout
    }
  end
end
