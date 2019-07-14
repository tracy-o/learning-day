defmodule Belfrage.Services.Webcore.ServiceWorker do
  use Belfrage.Services.Webcore.Lambda,
    arn: :service_worker_lambda_role_arn,
    lambda_function: :service_worker_lambda_function

  @impl Service
  def dispatch(struct) do
    response = lambda_client.call(arn(), lambda_function(), Request.build(struct))
    Struct.add(struct, :response, Response.build(response))
  end
end
