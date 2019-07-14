defmodule Belfrage.Services.Lambda.Pwa do
  use Belfrage.Services.Lambda.Lambda,
    [
      arn: :pwa_lambda_role_arn,
      lambda_function: :pwa_lambda_function
    ]

  @impl Service
  def dispatch(struct) do
    Struct.add(
      struct,
      :response,
      Response.build(lambda_client.call(arn(), lambda_function(), Request.build(struct)))
    )
  end
end
