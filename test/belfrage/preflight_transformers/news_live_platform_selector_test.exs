defmodule Belfrage.PreflightTransformers.NewsLivePlatformSelectorTest do
  use ExUnit.Case
  alias Belfrage.PreflightTransformers.NewsLivePlatformSelector
  alias Belfrage.{Envelope, Envelope.Request, Envelope.Private}

  import Test.Support.Helper, only: [set_environment: 1]

  describe "NEWS uses correct platform" do
    test "NEWS - if the asset ID is TIPO on test, WebCore is set" do
      set_environment("test")
      path_params = %{"asset_id" => "cdx4xqxrz39t"}

      assert NewsLivePlatformSelector.call(%Envelope{
               request: %Request{path_params: path_params}
             }) ==
               {:ok,
                %Envelope{
                  request: %Request{path_params: path_params},
                  private: %Private{platform: "Webcore"}
                }}
    end

    test "NEWS - if the asset ID is TIPO on live, WebCore is set" do
      set_environment("live")
      path_params = %{"asset_id" => "cdx4xqxrz39t"}

      assert NewsLivePlatformSelector.call(%Envelope{
               request: %Request{path_params: path_params}
             }) ==
               {:ok,
                %Envelope{
                  request: %Request{path_params: path_params},
                  private: %Private{platform: "Webcore"}
                }}
    end

    test "NEWS - when CPS URL with asset ID provided, show MozartNews on test" do
      set_environment("test")
      path_params = %{"asset_id" => "uk-66116088"}

      assert NewsLivePlatformSelector.call(%Envelope{
               request: %Request{path_params: path_params}
             }) ==
               {:ok,
                %Envelope{
                  request: %Request{path_params: path_params},
                  private: %Private{platform: "MozartNews"}
                }}
    end

    test "NEWS - when CPS URL with asset ID provided, show MozartNews on live" do
      set_environment("live")
      path_params = %{"asset_id" => "uk-66116088"}

      assert NewsLivePlatformSelector.call(%Envelope{
               request: %Request{path_params: path_params}
             }) ==
               {:ok,
                %Envelope{
                  request: %Request{path_params: path_params},
                  private: %Private{platform: "MozartNews"}
                }}
    end

    test "NEWS - when TIPO asset .app URL, show WebCore" do
      set_environment("live")
      path_params = %{"asset_id" => "cdx4xqxrz39t", "format" => "app"}

      assert NewsLivePlatformSelector.call(%Envelope{
               request: %Request{path_params: path_params}
             }) ==
               {:ok,
                %Envelope{
                  request: %Request{path_params: path_params},
                  private: %Private{platform: "Webcore"}
                }}
    end
  end
end
