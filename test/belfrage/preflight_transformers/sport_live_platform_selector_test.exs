defmodule Belfrage.PreflightTransformers.SportLivePlatformSelectorTest do
  use ExUnit.Case
  alias Belfrage.PreflightTransformers.SportLivePlatformSelector
  alias Belfrage.{Envelope, Envelope.Request, Envelope.Private}

  import Test.Support.Helper, only: [set_environment: 1]

  describe "SPORT uses correct platform" do
    test "SPORT - if the asset ID is TIPO on test, WebCore is set" do
      set_environment("test")
      path_params = %{"asset_id" => "cvpx5wr4nv8t"}

      assert SportLivePlatformSelector.call(%Envelope{
               request: %Request{path_params: path_params}
             }) ==
               {:ok,
                %Envelope{
                  request: %Request{path_params: path_params},
                  private: %Private{platform: "Webcore"}
                }}
    end

    test "SPORT - if the asset ID is TIPO on live, WebCore is set" do
      set_environment("live")
      path_params = %{"asset_id" => "cvpx5wr4nv8t"}

      assert SportLivePlatformSelector.call(%Envelope{
               request: %Request{path_params: path_params}
             }) ==
               {:ok,
                %Envelope{
                  request: %Request{path_params: path_params},
                  private: %Private{platform: "Webcore"}
                }}
    end

    test "SPORT - when CPS URL with asset ID provided, show MozartSport on test" do
      set_environment("test")
      path_params = %{"asset_id" => "23247541"}

      assert SportLivePlatformSelector.call(%Envelope{
               request: %Request{path_params: path_params}
             }) ==
               {:ok,
                %Envelope{
                  request: %Request{path_params: path_params},
                  private: %Private{platform: "MozartSport"}
                }}
    end

    test "SPORT - when CPS URL with asset ID provided, show MozartSport on live" do
      set_environment("live")
      path_params = %{"asset_id" => "23247541"}

      assert SportLivePlatformSelector.call(%Envelope{
               request: %Request{path_params: path_params}
             }) ==
               {:ok,
                %Envelope{
                  request: %Request{path_params: path_params},
                  private: %Private{platform: "MozartSport"}
                }}
    end

    test "SPORT - when TIPO asset .app URL, show WebCore" do
      set_environment("live")
      path_params = %{"asset_id" => "cvpx5wr4nv8t", "format" => "app"}

      assert SportLivePlatformSelector.call(%Envelope{
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
