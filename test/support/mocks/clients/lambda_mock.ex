defmodule Ingress.Clients.LambdaMock do
  @behaviour Ingress.Clients.Lambda
  alias Ingress.Clients.Lambda

  @impl Lambda
  def call(_arn, _function, _request) do
    {:ok, %{}}
  end
end
