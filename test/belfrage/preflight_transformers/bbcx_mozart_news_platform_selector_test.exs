defmodule Belfrage.PreflightTransformers.BBCXMozartNewsPlatformSelectorTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.PreflightTransformers.BBCXMozartNewsPlatformSelector
  alias Belfrage.{Envelope, Envelope.Request}

  test "when envelope data does not suffice bbcx selection, return MozartNews" do
    {:ok, response} =
      BBCXMozartNewsPlatformSelector.call(%Envelope{
        request: %Request{
          host: "www.bbc.com",
          country: "gb",
          raw_headers: %{"cookie-ckns_bbccom_beta" => "1"}
        },
        private: %Envelope.Private{production_environment: "test"}
      })

    assert response.private.platform == "MozartNews"
  end
end
