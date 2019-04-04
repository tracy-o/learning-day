defmodule Test.Support.StructHelper do
  alias Ingress.Struct
  alias Ingress.Struct.{Request, Private, Response, Debug}

  @base_request_struct %{path: "/_web_core"}

  @base_response_struct %{
    http_status: 200
  }
  @base_private_struct %{}
  @base_debug_struct %{}

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

  def debug_struct(overrides \\ %{}) do
    Debug
    |> struct(Map.merge(@base_debug_struct, overrides))
  end

  def build(override_options \\ []) do
    req_overrides = Keyword.get(override_options, :request, %{})
    priv_overrides = Keyword.get(override_options, :private, %{})
    resp_overrides = Keyword.get(override_options, :response, %{})
    debug_overrides = Keyword.get(override_options, :debug, %{})

    %Struct{
      request: request_struct(req_overrides),
      private: private_struct(priv_overrides),
      response: response_struct(resp_overrides),
      debug: debug_struct(debug_overrides)
    }
  end
end
