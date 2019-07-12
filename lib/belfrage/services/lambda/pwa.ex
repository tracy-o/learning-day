defmodule Belfrage.Services.Lambda.Pwa do
  alias Belfrage.Services.Lambda
  alias Belfrage.Struct

  alias Belfrage.Behaviours.Service
  @behaviour Service

  @arn Application.fetch_env!(:belfrage, :webcore_lambda_role_arn)
  @lambda_function Application.fetch_env!(:belfrage, :webcore_lambda_name_progressive_web_app)

  @impl Service
  def dispatch(struct), do: Lambda.dispatch(@arn, @lambda_function, struct)
end
