defmodule Belfrage.Services.Webcore do
  alias Belfrage.{Clients, Struct}
  alias Belfrage.Services.Webcore
  alias Belfrage.Behaviours.Service

  @behaviour Service

  @lambda_client Application.get_env(:belfrage, :lambda_client, Clients.Lambda)
  @production_environment Application.get_env(:belfrage, :production_environment)

  @impl Service
  def dispatch(struct = %Struct{private: private}) do
    Struct.add(
      struct,
      :response,
      Webcore.Response.build(@lambda_client.call(arn(), function_name(private), Webcore.Request.build(struct)))
    )
  end

  defp arn do
    Application.fetch_env!(:belfrage, :webcore_lambda_role_arn)
  end

  defp function_name(private = %Struct.Private{subdomain: "www"}) do
    "#{private.origin}:#{@production_environment}"
  end

  defp function_name(private = %Struct.Private{}) do
    "#{private.origin}:#{private.subdomain}"
  end
end
