defmodule Belfrage.Clients.HTTP.Response do
  alias Belfrage.Clients.HTTP

  defstruct [
    :status_code,
    :body,
    headers: %{}
  ]

  def new(params) do
    %__MODULE__{
      status_code: params.status_code,
      body: params.body,
      headers: HTTP.Headers.as_map(params.headers)
    }
  end
end
