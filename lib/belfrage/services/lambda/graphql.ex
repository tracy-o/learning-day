defmodule Belfrage.Services.Lambda.Graphql do
  alias Belfrage.Services.Lambda
  alias Belfrage.Struct

  alias Belfrage.Behaviours.Service
  @behaviour Service

  @arn Application.fetch_env!(:belfrage, :graphql_lambda_role_arn)
  @lambda_function Application.fetch_env!(:belfrage, :graphql_lambda_function)

  @impl Service
  def dispatch(struct), do: Lambda.dispatch(@arn, @lambda_function, struct)
end