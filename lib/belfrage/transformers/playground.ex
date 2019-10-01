defmodule Belfrage.Transformers.Playground do
  @moduledoc """
  Direct playground requests towards the playground lambda.

  This should be specified in the routespec pipeline before the 
  LambdaOriginAliasTransformer, if the alias is to be sent to the
  playground lambda.
  """
  use Belfrage.Transformers.Transformer

  @impl true
  def call(rest, struct = %Struct{request: %Struct.Request{playground?: true}}) do
    case playground_origin(struct.private.loop_id) do
      {:ok, playground_lamba_function_arn} ->
        struct = Struct.add(struct, :private, %{origin: playground_lamba_function_arn})
        then(rest, struct)

      {:warn, :playground_origin_not_set, type} ->
        Stump.log(:warn, %{
          msg: "Playground lambda function not set. Continuing request with unmodified struct.",
          config_value_name: type
        })

        then(rest, struct)
    end
  end

  @impl true
  def call(rest, struct) do
    then(rest, struct)
  end

  defp playground_origin("ContainerData") do
    playground_lambda_arn(:playground_api_lambda_function)
  end

  defp playground_origin(_) do
    playground_lambda_arn(:playground_pwa_lambda_function)
  end

  defp playground_lambda_arn(type) do
    case Application.get_env(:belfrage, type) do
      nil -> {:warn, :playground_origin_not_set, type}
      lambda_arn -> {:ok, lambda_arn}
    end
  end
end
