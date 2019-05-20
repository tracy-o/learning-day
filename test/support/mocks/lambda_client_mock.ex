defmodule Ingress.LambdaClientMock do
  @behaviour Ingress.LambdaClient
  alias Ingress.LambdaClient

  @impl LambdaClient
  def call_lambda(_role_name, _arn, _function, _request) do
    {200, "foobar"}
  end
end
