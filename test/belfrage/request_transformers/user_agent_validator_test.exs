defmodule Belfrage.RequestTransformers.UserAgentValidatorTest do
  use ExUnit.Case, async: true

  alias Belfrage.RequestTransformers.UserAgentValidator
  alias Belfrage.Envelope
  alias Belfrage.Envelope.Request

  for user_agent <- ~w(MozartFetcher MozartCli fabl) do
    test "request with user agent '#{user_agent}' is permitted" do
      envelope = %Envelope{request: %Request{user_agent: unquote(user_agent)}}
      assert UserAgentValidator.call(envelope) == {:ok, envelope}
    end
  end

  for user_agent <- ["foo", ""] do
    test "request with user agent '#{user_agent}' results in error 400" do
      envelope = %Envelope{request: %Request{user_agent: unquote(user_agent), req_svc_chain: "Belfrage"}}

      assert UserAgentValidator.call(envelope) ==
               {:stop,
                Envelope.add(envelope, :response, %{
                  http_status: 400,
                  headers: %{"cache-control" => "private", "req-svc-chain" => "Belfrage"}
                })}
    end
  end
end
