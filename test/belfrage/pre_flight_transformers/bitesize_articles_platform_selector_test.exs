defmodule Belfrage.PreFlightTransformers.BitesizeArticlesPlatformSelectorTest do
  use ExUnit.Case
  alias Belfrage.PreFlightTransformers.BitesizeArticlesPlatformSelector
  alias Belfrage.{Envelope, Envelope.Request, Envelope.Private}

  import Test.Support.Helper, only: [set_environment: 1]

  describe "requests with an id paramater key" do
    test "if the id is a test webcore id and the production environment is test Webcore is returned" do
      path_params = %{"id" => "zm8fhbk"}

      assert BitesizeArticlesPlatformSelector.call(%Envelope{
               request: %Request{path_params: path_params}
             }) ==
               {:ok,
                %Envelope{
                  request: %Request{path_params: path_params},
                  private: %Private{platform: "Webcore"}
                }}
    end

    test "if the id is a live webcore id and the production environment is live Webcore is returned" do
      set_environment("live")
      path_params = %{"id" => "zj8yydm"}

      assert BitesizeArticlesPlatformSelector.call(%Envelope{
               request: %Request{path_params: path_params}
             }) ==
               {:ok,
                %Envelope{
                  request: %Request{path_params: path_params},
                  private: %Private{platform: "Webcore"}
                }}
    end

    test "if the id is a not a test webcore id and the production environment is test MorphRouter is returned" do
      path_params = %{"id" => "some_id"}

      assert BitesizeArticlesPlatformSelector.call(%Envelope{
               request: %Request{path_params: path_params}
             }) ==
               {:ok,
                %Envelope{
                  request: %Request{path_params: path_params},
                  private: %Private{platform: "MorphRouter"}
                }}
    end

    test "if the id is a test webcore id and the production environment is live MorphRouter is returned" do
      set_environment("live")
      path_params = %{"id" => "zjykkmn"}

      assert BitesizeArticlesPlatformSelector.call(%Envelope{
               request: %Request{path_params: path_params}
             }) ==
               {:ok,
                %Envelope{
                  request: %Request{path_params: path_params},
                  private: %Private{platform: "MorphRouter"}
                }}
    end

    test "if the id is not a live webcore id and the production environment is live MorphRouter is returned" do
      set_environment("live")
      path_params = %{"id" => "some_id"}

      assert BitesizeArticlesPlatformSelector.call(%Envelope{
               request: %Request{path_params: path_params}
             }) ==
               {:ok,
                %Envelope{
                  request: %Request{path_params: path_params},
                  private: %Private{platform: "MorphRouter"}
                }}
    end
  end
end
