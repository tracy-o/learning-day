defmodule Belfrage.PreflightTransformers.BBCXMozartSportPlatformSelectorTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.PreflightTransformers.BBCXMozartSportPlatformSelector
  alias Belfrage.{Envelope, Envelope.Request}

  test "when envelope data does not suffice bbcx selection, return MozartSport" do
    {:ok, response} =
      BBCXMozartSportPlatformSelector.call(%Envelope{
        request: %Request{
          host: "www.bbc.com",
          country: "gb",
          raw_headers: %{"cookie-ckns_bbccom_beta" => "1"}
        },
        private: %Envelope.Private{production_environment: "test"}
      })

    assert response.private.platform == "MozartSport"
  end
end
