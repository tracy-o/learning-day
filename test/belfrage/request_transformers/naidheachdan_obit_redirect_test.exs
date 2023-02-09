defmodule Belfrage.RequestTransformers.NaidheachdanObitRedirectTest do
  use ExUnit.Case, async: true
  use Test.Support.Helper, :mox

  alias Belfrage.RequestTransformers.NaidheachdanObitRedirect
  alias Belfrage.Envelope

  @naidheachdan_request_envelope %Envelope{
    private: %Envelope.Private{origin: "https://www.bbc.com"},
    request: %Envelope.Request{
      host: "www.bbc.com",
      path: "/naidheachdan",
      scheme: :https
    }
  }

  describe "obit enabled" do
    test "/naidheachdan is redirected /news" do
      stub_dial(:obit_mode, "on")

      assert {
               :stop,
               %Belfrage.Envelope{
                 response: %Belfrage.Envelope.Response{
                   http_status: 302,
                   body: "Redirecting",
                   headers: %{
                     "location" => "https://www.bbc.com/news",
                     "x-bbc-no-scheme-rewrite" => "1",
                     "cache-control" => "public, stale-while-revalidate=10, max-age=60"
                   }
                 }
               }
             } = NaidheachdanObitRedirect.call(@naidheachdan_request_envelope)
    end
  end

  describe "obit disabled" do
    test "/naidheachdan is not redirected /news" do
      stub_dial(:obit_mode, "off")

      assert {
               :ok,
               @naidheachdan_request_envelope
             } = NaidheachdanObitRedirect.call(@naidheachdan_request_envelope)
    end
  end
end
