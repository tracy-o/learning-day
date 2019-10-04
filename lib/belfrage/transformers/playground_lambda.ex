defmodule Belfrage.Transformers.PlaygroundLambda do
  @moduledoc """
  Direct playground requests towards the playground lambda.

  This should be specified in the routespec pipeline before the 
  LambdaOriginAlias, if the alias is to be sent to the
  playground lambda.
  """
  use Belfrage.Transformers.Transformer

  @impl true
  def call(rest, struct = %Struct{request: %Struct.Request{playground?: true}}) do
    struct = Struct.add(struct, :private, %{origin: playground_origin(struct.private.loop_id)})
    then(rest, struct)
  end

  @impl true
  def call(rest, struct) do
    then(rest, struct)
  end

  defp playground_origin("ContainerData") do
    Application.get_env(:belfrage, :playground_api_lambda_function)
  end

  defp playground_origin(_) do
    Application.get_env(:belfrage, :playground_pwa_lambda_function)
  end
end
