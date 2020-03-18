defmodule Belfrage.Transformers.LambdaOriginAliasTest do
  use ExUnit.Case

  alias Belfrage.Transformers.LambdaOriginAlias
  alias Belfrage.Struct

  test "the production_environment is used as the alias" do
    production_env = Application.get_env(:belfrage, :production_environment)

    struct = %Struct{
      private: %Struct.Private{origin: "lambda-function", production_environment: "test"}
    }

    {:ok, %Struct{private: %Struct.Private{origin: origin}}} = LambdaOriginAlias.call([], struct)

    assert origin == "lambda-function:#{production_env}"
  end

  test "the production_environment is used as the alias when preview_mode is off" do
    production_env = Application.get_env(:belfrage, :production_environment)

    struct = %Struct{
      private: %Struct.Private{origin: "lambda-function", production_environment: "test", preview_mode: "off"}
    }

    {:ok, %Struct{private: %Struct.Private{origin: origin}}} = LambdaOriginAlias.call([], struct)

    assert origin == "lambda-function:#{production_env}"
  end

  test "the subdomain is used as the alias when preview_mode is on" do
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
end
