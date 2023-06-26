defmodule Belfrage.PreflightTransformers.BBCXWebcorePlatformSelectorTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.PreflightTransformers.BBCXWebcorePlatformSelector
  alias Belfrage.{Envelope, Envelope.Request}

  test "when envelope data does not suffice bbcx selection, return Webcore" do
    {:ok, response} =
      BBCXWebcorePlatformSelector.call(%Envelope{
        request: %Request{
          host: "www.bbc.com",
          country: "gb",
          raw_headers: %{"cookie-ckns_bbccom_beta" => "1"}
        },
        private: %Envelope.Private{production_environment: "test"}
      })

    assert response.private.platform == "Webcore"
  end
end
