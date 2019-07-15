defmodule Belfrage.Services.Webcore.ServiceWorker do
  alias Belfrage.{Clients, Struct}
  alias Belfrage.Services.Webcore.{Request, Response}
  alias Belfrage.Behaviours.Service

  @behaviour Service

  @arn Application.fetch_env!(:belfrage, :webcore_lambda_role_arn)
  @lambda_function Application.fetch_env!(:belfrage, :service_worker_lambda_function)
  @lambda_client Application.get_env(:belfrage, :lambda_client, Clients.Lambda)

  @impl Service
  def dispatch(struct) do
    Struct.add(
      struct,
      :response,
      Response.build(@lambda_client.call(@arn, @lambda_function, Request.build(struct)))
    )
  end
end
