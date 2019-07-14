defmodule Belfrage.Services.Lambda.Graphql do
  use Belfrage.Services.Lambda.Lambda,
    [
      arn: :graphql_lambda_role_arn,
      lambda_function: :graphql_lambda_function
    ]

  @impl Service
  def dispatch(struct) do
    response = lambda_client.call(arn(), lambda_function(), Request.build(struct))
    Struct.add(struct, :response, Response.build(response))
  end
end
