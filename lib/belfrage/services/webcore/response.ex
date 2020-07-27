defmodule Belfrage.Services.Webcore.Response do
  require Belfrage.Event

  alias Belfrage.Struct

  def build({:error, :function_not_found}) do
    %Struct.Response{
      http_status: 404,
      headers: %{},
      body: "404 - not found"
    }
  end

  def build({:error, _reason}) do
    %Struct.Response{
      http_status: 500,
      headers: %{},
      body: ""
    }
  end

  def build({:ok, lambda_response = %{"body" => body, "isBase64Encoded" => true}}) do
    case Base.decode64(body) do
      {:ok, decoded_body} ->
        build({
          :ok,
          Map.merge(lambda_response, %{
            "body" => decoded_body,
            "isBase64Encoded" => false
          })
        })

      :error ->
        Belfrage.Event.record(:log, :error, %{
          msg: "Failed to base64 decode response body."
        })

        build({:error, :failed_base_64_decode})
    end
  end

  def build({:ok, %{"body" => body, "headers" => headers, "statusCode" => http_status}}) do
    Belfrage.Event.record(:metric, :increment, "service.lambda.response.#{http_status}")

    %Struct.Response{
      http_status: http_status,
      headers: stringify(headers),
      body: body
    }
  end

  def build({:ok, invalid_response_from_web_core}) do
    Belfrage.Event.record(:log, :error, %{
      msg: "Received an invalid response from web core",
      web_core_response: invalid_response_from_web_core
    })

    Belfrage.Event.record(:metric, :increment, "service.lambda.response.invalid_web_core_contract")

    %Struct.Response{
      http_status: 500,
      headers: %{},
      body: ""
    }
  end

  defp stringify(headers) do
    Enum.map(headers, fn {key, value} ->
      {key, to_string(value)}
    end)
    |> Enum.into(%{})
  end
end
