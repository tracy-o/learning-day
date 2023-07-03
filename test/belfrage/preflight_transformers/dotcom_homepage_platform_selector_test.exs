defmodule Belfrage.PreflightTransformers.DotComHomepagePlatformSelectorCommonTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.PreflightTransformers.DotComHomepagePlatformSelector
  alias Belfrage.{Envelope, Envelope.Request}


  test "when the host is bbc.com then the DotCom platform is used" do
    {:ok, response} =
      DotComHomepagePlatformSelector.call(
        %Envelope{
          request: %Request{
            host: "www.bbc.com",
          }
        }
      )

    assert response.private.platform == "DotComHomepage"
  end

  test "when the host is bbc.co.uk then Webcore is used" do
    {:ok, response} =
      DotComHomepagePlatformSelector.call(
        %Envelope{
          request: %Request{
            host: "www.bbc.co.uk",
          }
        }
      )

    assert response.private.platform == "Webcore"
  end

  test "when the host is localhost then Webcore is used" do
    {:ok, response} =
      DotComHomepagePlatformSelector.call(
        %Envelope{
          request: %Request{
            host: "localhost",
          }
        }
      )

    assert response.private.platform == "Webcore"
  end

  test "when the host is empty then Webcore is used" do
    {:ok, response} =
      DotComHomepagePlatformSelector.call(
        %Envelope{
          request: %Request{
            host: "",
          }
        }
      )

    assert response.private.platform == "Webcore"
  end
end
