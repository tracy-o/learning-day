defmodule Belfrage.RequestTransformers.NewsAppsHardcodedResponseTest do
  use ExUnit.Case, async: true
  use Test.Support.Helper, :mox

  alias Belfrage.RequestTransformers.NewsAppsHardcodedResponse
  alias Belfrage.Envelope
  alias Belfrage.Utils.Current

  defp envelope do
    %Envelope{
      private: %Envelope.Private{
        platform: "Fabl"
      }
    }
  end

  describe "when the Dial is disabled (default)" do
    test "traffic is proxied to origin" do
      stub_dials(news_apps_hardcoded_response: "disabled")
      original_envelope = envelope()

      assert {:ok, ^original_envelope} = NewsAppsHardcodedResponse.call(original_envelope)
    end
  end

  describe "when the Dial is enabled" do
    test "an early response is returned" do
      stub_dials(news_apps_hardcoded_response: "enabled")

      assert {
               :stop,
               %Belfrage.Envelope{
                 response: %Belfrage.Envelope.Response{
                   http_status: 200,
                   headers: %{
                     "content-type" => "application/json; charset=utf-8",
                     "cache-control" => "public, max-age=5",
                     "content-encoding" => "gzip"
                   }
                 }
               }
             } = NewsAppsHardcodedResponse.call(envelope())
    end

    test "the response body is hardocded" do
      stub_dials(news_apps_hardcoded_response: "enabled")
      Current.Mock.freeze(~D[2022-12-02], ~T[11:14:52.368815Z])
      Belfrage.NewsApps.Failover.update()

      {
        :stop,
        %Belfrage.Envelope{
          response: %Belfrage.Envelope.Response{body: body}
        }
      } = NewsAppsHardcodedResponse.call(envelope())

      # checks that JSON is parseable
      parsed_body = body |> :zlib.gunzip() |> Json.decode!()

      assert parsed_body["data"]["metadata"]["name"] == "Home"
      assert parsed_body["data"]["metadata"]["lastUpdated"] == 1_669_978_800_000
      on_exit(&Current.Mock.unfreeze/0)
    end
  end
end
