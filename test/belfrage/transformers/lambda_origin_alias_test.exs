defmodule Belfrage.Transformers.LambdaOriginAliasTest do
  use ExUnit.Case

  alias Belfrage.Transformers.LambdaOriginAlias
  alias Belfrage.Struct

  describe "when preview mode boolean is non existant" do
    test "the production_environment is used as the alias" do
      production_env = Application.get_env(:belfrage, :production_environment)

      struct = %Struct{
        private: %Struct.Private{origin: "lambda-function", production_environment: "test"}
      }

      {:ok, %Struct{private: %Struct.Private{origin: origin}}} = LambdaOriginAlias.call([], struct)

      assert origin == "lambda-function:#{production_env}"
    end
  end

  describe "when the preview mode is off" do
    test "the production_environment is used as the alias" do
      production_env = Application.get_env(:belfrage, :production_environment)

      struct = %Struct{
        private: %Struct.Private{origin: "lambda-function", production_environment: "test", preview_mode: "off"}
      }

      {:ok, %Struct{private: %Struct.Private{origin: origin}}} = LambdaOriginAlias.call([], struct)

      assert origin == "lambda-function:#{production_env}"
    end
  end

  describe "when preview mode is on" do
    test "if valid the subdomain will be used as the alias" do
      struct = %Struct{
        request: %Struct.Request{subdomain: "example-branch"},
        private: %Struct.Private{
          loop_id: "SportVideos",
          origin: "lambda-function",
          production_environment: "test",
          preview_mode: "on"
        }
      }

      {:ok, %Struct{private: %Struct.Private{origin: origin}}} = LambdaOriginAlias.call([], struct)

      assert origin == "lambda-function:example-branch"
    end

    test "if the subdomain is invalid a 400 will be returned" do
      struct = %Struct{
        request: %Struct.Request{subdomain: "*"},
        private: %Struct.Private{
          loop_id: "SportVideos",
          origin: "lambda-function",
          production_environment: "test",
          preview_mode: "on"
        }
      }

      assert {
               :stop_pipeline,
               %Belfrage.Struct{
                 response: %Belfrage.Struct.Response{
                   http_status: 400,
                   body: "Invalid Alias"
                 }
               }
             } = LambdaOriginAlias.call([], struct)
    end
  end
end
