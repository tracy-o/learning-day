defmodule Test.Support.StructHelper do
  alias Ingress.Struct
  alias Ingress.Struct.{Request, Private, Response}

  @base_request_struct %{path: "_web_core"}

  @base_response_struct %{
    http_status: 200
  }
  @base_private_struct %{}

  def response_struct(overrides \\ %{}) do
    Response
    |> struct(Map.merge(@base_response_struct, overrides))
  end

  def request_struct(overrides \\ %{}) do
    Request
    |> struct(Map.merge(@base_request_struct, overrides))
  end

  def private_struct(overrides \\ %{}) do
    Private
    |> struct(Map.merge(@base_private_struct, overrides))
  end

  def build(override_options \\ []) do
    req_over = Keyword.get(override_options, :request, %{})
    priv_over = Keyword.get(override_options, :private, %{})
    resp_over = Keyword.get(override_options, :response, %{})

    %Struct{
      request: request_struct(req_over),
      private: private_struct(priv_over),
      response: response_struct(resp_over)
    }
  end
end
