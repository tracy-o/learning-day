defmodule Belfrage.PreflightTransformers.ClassicAppsPlatformSelectorTest do
  use ExUnit.Case

  alias Routes.Platforms.ClassicApps
  alias Belfrage.PreflightTransformers.ClassicAppsPlatformSelector
  alias Belfrage.{Envelope, Envelope.Request}

  describe "when subdomain is 'news-app-classic'" do
    test "returns the Trevor platform" do
      {:ok, response} =
        ClassicAppsPlatformSelector.call(%Envelope{
          request: %Request{subdomain: "news-app-classic"}
        })

      assert response.private.platform == "AppsTrevor"
    end
  end

  describe "when subdomain is 'news-app-global-classic'" do
    test "returns the Walter platform" do
      {:ok, response} =
        ClassicAppsPlatformSelector.call(%Envelope{
          request: %Request{subdomain: "news-app-global-classic"}
        })

      assert response.private.platform == "AppsWalter"
    end
  end

  describe "when subdomain is 'news-app-ws-classic'" do
    test "returns the Philippa platform" do
      {:ok, response} =
        ClassicAppsPlatformSelector.call(%Envelope{
          request: %Request{subdomain: "news-app-ws-classic"}
        })

      assert response.private.platform == "AppsPhilippa"
    end
  end

  describe "when subdomain is unexpected" do
    test "returns a 400 response" do
      assert {:error, %Envelope{}, 400} ==
               ClassicAppsPlatformSelector.call(%Envelope{
                 request: %Request{subdomain: "www"}
               })
    end
  end
end
