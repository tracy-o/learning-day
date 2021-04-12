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

  describe "when a UserAgent is received and the value is MozartFetcher" do
    test "we receive :ok and the pipeline continues" do
      struct = incoming_request("/", "MozartFetcher")

      assert {:ok, struct} = UserAgentValidator.call(@rest, struct)
    end
  end

  describe "when a UserAgent is received and the value is not MozartFetcher" do
    test "we receive :stop_pipeline and the struct" do
      struct = incoming_request("/", "NotMozartFetcher")

      assert {:stop_pipeline, struct} = UserAgentValidator.call(@rest, struct)
    end

    test "we return a 400 in the struct response" do
      struct = incoming_request("/", "NotMozartFetcher")
      {_, struct} = UserAgentValidator.call(@call, struct)

      assert %Struct.Response{
               http_status: 400,
               headers: %{
                 "req-svc-chain" => "Belfrage",
                 "cache-control" => "private"
               }
             } = struct.response
    end
  end

  describe "when an empty UserAgent string is received it returns a 400" do
    test "we receive :stop_pipeline and the struct" do
      struct = incoming_request("/", "")

      assert {:stop_pipeline, struct} = UserAgentValidator.call(@rest, struct)
    end

    test "we return a 400 in the struct response" do
      struct = incoming_request("/", "NotMozartFetcher")
      {_, struct} = UserAgentValidator.call(@call, struct)

      assert %Struct.Response{
               http_status: 400,
               headers: %{
                 "req-svc-chain" => "Belfrage",
                 "cache-control" => "private"
               }
             } = struct.response
    end
  end
end
