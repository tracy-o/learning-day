defmodule Ingress.Services.Lambda do
  alias Ingress.Struct
  alias Ingress.Behaviours.Service
  @behaviour Service

  @impl Service
  def dispatch(struct = %Struct{request: %Struct.Request{payload: payload}}) do
    {status, body} =
      InvokeLambda.invoke(lambda_function(), %{
        instance_role_name: instance_role_name(),
        lambda_role_arn: lambda_role_arn(),
        function_payload: payload
      })

    Map.put(struct, :response, %Struct.Response{http_status: status, body: body})
  end

  defp instance_role_name() do
    Application.fetch_env!(:ingress, :instance_role_name)
  end

  defp lambda_role_arn() do
    Application.fetch_env!(:ingress, :lambda_presentation_role)
  end

  defp lambda_function() do
    Application.fetch_env!(:ingress, :lambda_presentation_layer)
  end
end
