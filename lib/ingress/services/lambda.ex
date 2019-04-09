defmodule Ingress.Services.Lambda do
  use ExMetrics

  alias Ingress.Struct
  alias Ingress.Behaviours.Service
  @behaviour Service

  @impl Service
  def dispatch(struct = %Struct{request: request}) do
    {status, body} =
      ExMetrics.timeframe "function.timing.service.lambda.invoke" do
        InvokeLambda.invoke(lambda_function(), %{
          instance_role_name: instance_role_name(),
          lambda_role_arn: lambda_role_arn(),
          function_payload: request
        })
      end

    ExMetrics.increment("service.lambda.response.#{status}")
    log(status, body, struct)
    Map.put(struct, :response, %Struct.Response{http_status: status, body: body})
  end

  defp log(status, body, struct) when status > 200 do
    Stump.log(:error, %{
      msg: "Lambda Service returned a non 200 status",
      http_status: status,
      body: body,
      lambda_function: lambda_function(),
      struct: Map.from_struct(struct)
    })
  end

  defp log(_, _, _), do: nil

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
