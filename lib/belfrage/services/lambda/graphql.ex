defmodule Belfrage.Services.Lambda.Graphql do
  alias Belfrage.{Clients, Struct}
  alias Belfrage.Services.Lambda.{Request, Response}

  alias Belfrage.Behaviours.Service
  @behaviour Service

  @arn Application.fetch_env!(:belfrage, :graphql_lambda_role_arn)
  @lambda_function Application.fetch_env!(:belfrage, :graphql_lambda_function)
  @lambda_client Application.get_env(:belfrage, :lambda_client, Clients.Lambda)

  @impl Service
  def dispatch(struct) do
    response = @lambda_client.call(@arn, @lambda_function, Request.build(struct))
    Struct.add(struct, :response, Response.build(response))
  end
end
