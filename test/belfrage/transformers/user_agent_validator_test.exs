defmodule Belfrage.Transformers.UserAgentValidatorTest do
  use ExUnit.Case

  alias Belfrage.Transformers.UserAgentValidator
  alias Belfrage.Struct

  @rest []

  defp incoming_request(path, user_agent) do
    %Struct{
      request: %Struct.Request{
        method: :get,
        path: path,
        user_agent: user_agent,
        req_svc_chain: "Belfrage"
      }
    }
  end

  describe "call/2" do
    test "when the UserAgent is MozartFetcher the request continues" do
      struct = incoming_request("/", "MozartFetcher")

      assert {:ok, struct} == UserAgentValidator.call(@rest, struct)
    end

    test "when the UserAgent is not MozartFetcher but has a value it returns a 400" do
      struct = incoming_request("/", "NotMozartFetcher")

      assert {:stop_pipeline, struct} == UserAgentValidator.call(@rest, struct)

      assert %Struct.Response{
               http_status: 400,
               headers: %{
                 "req-svc-chain" => "Belfrage"
               }
             } = struct.response
    end

    test "when the UserAgent is an empty string it returns a 400" do
      struct = incoming_request("/", "")

      assert {:stop_pipeline, struct} == UserAgentValidator.call(@rest, struct)

      assert %Struct.Response{
               http_status: 400,
               headers: %{
                 "req-svc-chain" => "Belfrage"
               }
             } = struct.response
    end
  end
end
