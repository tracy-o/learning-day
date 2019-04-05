defmodule Ingress.Services.HTTP do
  alias Ingress.Behaviours.Service
  alias Ingress.HTTPClient
  alias Ingress.Struct

  @behaviour Service

  @impl Service
  def dispatch(struct = %{request: request}) do
    #host = struct.request()
  end
end
