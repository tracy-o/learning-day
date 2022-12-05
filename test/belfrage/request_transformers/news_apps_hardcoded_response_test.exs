defmodule Belfrage.RequestTransformers.NewsAppsHardcodedResponseTest do
  use ExUnit.Case, async: true
  use Test.Support.Helper, :mox

  alias Belfrage.RequestTransformers.NewsAppsHardcodedResponse
  alias Belfrage.Struct
  alias Belfrage.Utils.Current

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

  describe "when the Dial is enabled" do
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
      Current.Mock.freeze(~D[2022-12-02], ~T[11:14:52.368815Z])

      {
        :stop_pipeline,
        %Belfrage.Struct{
          response: %Belfrage.Struct.Response{body: body}
        }
      } = NewsAppsHardcodedResponse.call([], struct())

      # cheks that JSON is parseable
      parsed_body = Json.decode!(body)

      assert parsed_body["data"]["metadata"]["name"] == "Home"
      assert parsed_body["data"]["metadata"]["lastUpdated"] == 1_669_978_800_000
      on_exit(&Current.Mock.unfreeze/0)
    end
  end
end
