defmodule Ingress.Services.Lambda do
  use ExMetrics

  alias Ingress.Struct
  alias Ingress.Behaviours.Service
  @behaviour Service

  @lambda_client Application.get_env(:ingress, :lambda_client, LambdaClient)

  @impl Service
  def dispatch(struct = %Struct{request: request}) do
    {status, body} =
      ExMetrics.timeframe "function.timing.service.lambda.invoke" do
        {:ok, %{body: credentials}} =
          ExAws.STS.assume_role(lambda_role_arn(), "lambda-role")
          |> ExAws.request()

        ExAws.Lambda.invoke(instance_role_name(), request, %{})
        |> ExAws.request(
          security_token: credentials.session_token,
          access_key_id: credentials.access_key_id,
          secret_access_key: credentials.secret_access_key
        )
      end

    ExMetrics.increment("service.lambda.response.#{status}")
    if status > 200, do: log(status, body, struct)
    Map.put(struct, :response, %Struct.Response{http_status: status, body: body})
  end

  defp log(status, body, struct) do
    Stump.log(:error, %{
      msg: "Lambda Service returned a non 200 status",
      http_status: status,
      body: body,
      lambda_function: lambda_function(),
      struct: Map.from_struct(struct)
    })
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
