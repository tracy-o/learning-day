defmodule Belfrage.RequestTransformers.NewsAppsHardcodedResponseTest do
  use ExUnit.Case, async: true
  use Test.Support.Helper, :mox

  alias Belfrage.RequestTransformers.NewsAppsHardcodedResponse
  alias Belfrage.Struct

  defp struct do
    %Struct{
      private: %Struct.Private{
        platform: Fabl
      }
    }
  end

  describe "when the Dial is disabled (default)" do
    test "traffic is proxied to origin" do
      stub_dials(news_apps_hardcoded_response: "disabled")
      original_struct = struct()

      assert {:ok, ^original_struct} = NewsAppsHardcodedResponse.call([], original_struct)
    end
  end

  describe "when the Dial is anabled" do
    test "an early response is returned" do
      stub_dials(news_apps_hardcoded_response: "enabled")

      assert {
               :stop_pipeline,
               %Belfrage.Struct{
                 response: %Belfrage.Struct.Response{
                   http_status: 200
                 }
               }
             } = NewsAppsHardcodedResponse.call([], struct())
    end

    test "the response body is hardocded" do
      stub_dials(news_apps_hardcoded_response: "enabled")

      {
        :stop_pipeline,
        %Belfrage.Struct{
          response: %Belfrage.Struct.Response{body: body}
        }
      } = NewsAppsHardcodedResponse.call([], struct())

      parsed_body = Json.decode!(body)

      assert parsed_body["data"]["metadata"]["name"] == "Home"
    end
  end
end
