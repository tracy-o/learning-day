defmodule Belfrage.Services.Webcore.Response do
  require Belfrage.Event

  alias Belfrage.Struct

  def build({:error, :function_not_found}, _preview_mode = "on") do
    %Struct.Response{
      http_status: 404,
      headers: %{},
      body: "404 - not found"
    }
  end

  def build({:error, _reason}, _preview_mode) do
    %Struct.Response{
      http_status: 500,
      headers: %{},
      body: ""
    }
  end

  def build({:ok, lambda_response = %{"body" => body, "isBase64Encoded" => true}}, preview_mode) do
    try do
      decoded_body = :b64fast.decode64(body)

      build(
        {
          :ok,
          %{lambda_response | "body" => decoded_body, "isBase64Encoded" => false}
        },
        preview_mode
      )
    rescue
      ArgumentError ->
        Belfrage.Event.record(:log, :error, %{
          msg: "Failed to base64 decode response body."
        })

        build({:error, :failed_base_64_decode}, preview_mode)
    end
  end

  def build({:ok, %{"body" => body, "headers" => headers, "statusCode" => http_status}}, _preview_mode) do
    Belfrage.Event.record(:metric, :increment, "service.lambda.response.#{http_status}")

    %Struct.Response{
      http_status: http_status,
      headers: stringify(headers),
      body: body
    }
  end

  def build({:ok, invalid_response_from_web_core}, _preview_mode) do
    Belfrage.Event.record(:log, :debug, %{
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
