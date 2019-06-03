defmodule Ingress.Services.Lambda do
  use ExMetrics

  alias Ingress.{Clients, Struct}
  alias Ingress.Behaviours.Service
  @behaviour Service

  @lambda_client Application.get_env(:ingress, :lambda_client, Clients.Lambda)

  @impl Service
  def dispatch(struct = %Struct{request: request}) do
    response =
      @lambda_client.call(
        instance_role_name(),
        lambda_role_arn(),
        lambda_function(),
        build_payload(struct)
      )
      |> format_invoke_response()

    Struct.add(struct, :response, response)
  end

  defp build_payload(struct) do
    %{
      headers: %{
        country: struct.request.country
      },
      body: struct.request.payload,
      httpMethod: struct.request.method
    }
  end

  defp format_invoke_response({:error, _reason}) do
    %Struct.Response{
      http_status: 500,
      headers: %{},
      body: "",
      cacheable_content: true
    }
  end

  defp format_invoke_response(
         {:ok, %{"body" => body, "headers" => headers, "statusCode" => http_status}}
       ) do
    %Struct.Response{
      http_status: http_status,
      headers: headers,
      body: body,
      cacheable_content: true
    }
  end

  defp format_invoke_response({:ok, invalid_response_from_web_core}) do
    Stump.log(:error, %{
      msg: "Received an invalid response from web core",
      web_core_response: invalid_response_from_web_core
    })

    %Struct.Response{
      http_status: 500,
      headers: %{},
      body: "",
      cacheable_content: true
    }
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
