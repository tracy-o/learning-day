defmodule Ingress.Clients.LambdaMock do
  @behaviour Ingress.Clients.Lambda
  alias Ingress.Clients.Lambda

  @impl Lambda
  def call(_role_name, _arn, _function, _request) do
    {200, "foobar"}
  end
end
