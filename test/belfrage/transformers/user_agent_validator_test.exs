defmodule Belfrage.Transformers.UserAgentValidatorTest do
  use ExUnit.Case, async: true

  alias Belfrage.Transformers.UserAgentValidator
  alias Belfrage.Struct
  alias Belfrage.Struct.Request

  for user_agent <- ~w(MozartFetcher MozartCli fabl) do
    test "request with user agent '#{user_agent}' is permitted" do
      struct = %Struct{request: %Request{user_agent: unquote(user_agent)}}
      assert UserAgentValidator.call([], struct) == {:ok, struct}
    end
  end

  for user_agent <- ["foo", ""] do
    test "request with user agent '#{user_agent}' results in error 400" do
      struct = %Struct{request: %Request{user_agent: unquote(user_agent), req_svc_chain: "Belfrage"}}

      assert UserAgentValidator.call([], struct) ==
               {:stop_pipeline,
                Struct.add(struct, :response, %{
                  http_status: 400,
                  headers: %{"cache-control" => "private", "req-svc-chain" => "Belfrage"}
                })}
    end
  end
end
