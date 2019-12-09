defmodule Belfrage.Services.Webcore do
  alias Belfrage.{Clients, Struct}
  alias Belfrage.Services.Webcore
  alias Belfrage.Behaviours.Service

  @behaviour Service

  @lambda_client Application.get_env(:belfrage, :lambda_client, Clients.Lambda)

  @impl Service
  def dispatch(struct = %Struct{private: private}) do
    Struct.add(
      struct,
      :response,
      Webcore.Response.build(@lambda_client.call(arn(struct), private.origin, Webcore.Request.build(struct)))
    )
  end

  defp arn(_) do
    Application.fetch_env!(:belfrage, :webcore_lambda_role_arn)
  end
end
