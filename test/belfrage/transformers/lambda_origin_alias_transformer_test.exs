defmodule Belfrage.Transformers.LambdaOriginAliasTransformerTest do
  use ExUnit.Case

  alias Belfrage.Transformers.LambdaOriginAliasTransformer
  alias Belfrage.Struct

  @struct_with_default_subdomain %Struct{private: %Struct.Private{origin: "lambda-function"}}

  @struct_with_custom_subdomain %Struct{
    private: %Struct.Private{origin: "lambda-function", subdomain: "example-branch"}
  }

  test "The default www subdomain will add the production env as the alias" do
    production_env = Application.get_env(:belfrage, :production_environment)

    {:ok, %Struct{private: %Struct.Private{origin: origin}}} =
      LambdaOriginAliasTransformer.call([], @struct_with_default_subdomain)

    assert origin == "lambda-function:#{production_env}"
  end

  test "custom subdomains are used as the alias for the origin" do
    {:ok, %Struct{private: %Struct.Private{origin: origin}}} =
      LambdaOriginAliasTransformer.call([], @struct_with_custom_subdomain)

    assert origin == "lambda-function:example-branch"
  end
end
