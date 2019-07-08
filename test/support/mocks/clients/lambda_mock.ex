defmodule Belfrage.Clients.LambdaMock do
  @behaviour Belfrage.Clients.Lambda
  alias Belfrage.Clients.Lambda

  @impl Lambda
  def call(_arn, _function, _request) do
    {:ok, %{}}
  end
end
