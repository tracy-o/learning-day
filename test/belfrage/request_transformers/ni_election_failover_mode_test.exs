defmodule Belfrage.RequestTransformers.NiElectionFailoverModeTest do
  use ExUnit.Case, async: true
  use Test.Support.Helper, :mox

  alias Belfrage.Envelope

  alias Belfrage.RequestTransformers.NiElectionFailoverMode

  defp envelope do
    %Envelope{
      private: %Envelope.Private{
        platform: "Webcore"
      }
    }
  end

  describe "when the Dial is disabled (default)" do
    test "traffic is proxied to origin" do
      stub_dials(ni_election_failover: "off")
      original_envelope = envelope()

      assert {:ok, ^original_envelope} = NiElectionFailoverMode.call(original_envelope)
    end
  end

  describe "when the Dial is enabled" do
    test "an early response is returned" do
      stub_dials(ni_election_failover: "on")

      assert {
               :stop,
               %Belfrage.Envelope{
                 response: %Belfrage.Envelope.Response{
                   http_status: 302,
                   body: "Redirecting",
                   headers: %{
                     "location" => "https://www.bbc.co.uk/news",
                     "x-bbc-no-scheme-rewrite" => "1",
                     "cache-control" => "public, stale-while-revalidate=10, max-age=60"
                   }
                 }
               }
             } = NiElectionFailoverMode.call(envelope())
    end
  end
end
