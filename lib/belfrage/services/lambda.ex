defmodule Belfrage.Services.Lambda do
  use ExMetrics

  alias Belfrage.{Clients, Struct}

  @lambda_client Application.get_env(:belfrage, :lambda_client, Clients.Lambda)

  def dispatch(arn, lambda_function, struct) do
    response =
      @lambda_client.call(
        arn,
        lambda_function,
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
      httpMethod: struct.request.method,
      path: struct.request.path
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

  defp format_invoke_response({:ok, %{"body" => body, "headers" => headers, "statusCode" => http_status}}) do
    ExMetrics.increment("service.lambda.response.#{http_status}")

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
end
