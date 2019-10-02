defmodule Belfrage.Transformers.LambdaOriginAliasTransformerTest do
  use ExUnit.Case

  alias Belfrage.Transformers.LambdaOriginAliasTransformer
  alias Belfrage.Struct

  @struct_with_default_subdomain %Struct{private: %Struct.Private{origin: "lambda-function"}}

  @struct_with_custom_subdomain %Struct{
    request: %Struct.Request{subdomain: "example-branch"},
    private: %Struct.Private{loop_id: "SportVideos", origin: "lambda-function"}
  }

  test "The default www subdomain will add the production env as the alias" do
    production_env = Application.get_env(:belfrage, :production_environment)

    {:ok, %Struct{private: %Struct.Private{origin: origin}}} =
      LambdaOriginAliasTransformer.call([], @struct_with_default_subdomain)

    assert origin == "lambda-function:#{production_env}"
  end

  test "custom subdomains are used as the alias for the origin for PWA" do
    {:ok, %Struct{private: %Struct.Private{origin: origin}}} =
      LambdaOriginAliasTransformer.call([], @struct_with_custom_subdomain)

    assert origin == "preview-pwa-lambda-function:example-branch"
  end

  test "custom subdomains are used as the alias for the origin for ContainerData" do
    api_struct = Belfrage.Struct.add(@struct_with_custom_subdomain, :private, %{loop_id: "ContainerData"})

    {:ok, %Struct{private: %Struct.Private{origin: origin}}} = LambdaOriginAliasTransformer.call([], api_struct)

    assert origin == "preview-api-lambda-function:example-branch"
  end

  describe "playground requests" do
    test "function is not changed for ad-hoc requests to the belfrage playground lambda" do
      api_struct =
        @struct_with_custom_subdomain
        |> Belfrage.Struct.add(:request, %{playground?: true})

      {:ok, %Struct{private: %Struct.Private{origin: origin}}} = LambdaOriginAliasTransformer.call([], api_struct)

      assert origin == "lambda-function:example-branch"
    end
  end
end
