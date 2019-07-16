defmodule Belfrage.Services.Webcore.Response do
  use ExMetrics

  alias Belfrage.Struct

  def build({:error, _reason}) do
    %Struct.Response{
      http_status: 500,
      headers: %{},
      body: "",
      cacheable_content: true
    }
  end

  def build({:ok, %{"body" => body, "headers" => headers, "statusCode" => http_status}}) do
    ExMetrics.increment("service.lambda.response.#{http_status}")

    %Struct.Response{
      http_status: http_status,
      headers: headers,
      body: body,
      cacheable_content: true
    }
  end

  def build({:ok, invalid_response_from_web_core}) do
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
