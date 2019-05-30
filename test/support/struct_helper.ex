defmodule Test.Support.StructHelper do
  alias Ingress.Struct
  alias Ingress.Struct.{Request, Private, Response, Debug}

  @base_request_struct %{path: "/_web_core", method: "GET"}

  def response_struct(overrides \\ %{}) do
    struct(Response, overrides)
  end

  def request_struct(overrides \\ %{}) do
    struct(Request, Map.merge(@base_request_struct, overrides))
  end

  def private_struct(overrides \\ %{}) do
    struct(Private, Map.merge(%{cache_ttl: 30}, overrides))
  end

  def debug_struct(overrides \\ %{}) do
    struct(Debug, overrides)
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
