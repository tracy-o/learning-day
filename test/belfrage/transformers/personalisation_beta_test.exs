defmodule Belfrage.Transformers.PersonalisationBetaTest do
  use ExUnit.Case
  alias Belfrage.Struct
  alias Belfrage.Transformers.PersonalisationBeta
  alias Fixtures.AuthToken

  import ExUnit.CaptureLog

  @struct_with_auth_user %Struct{
    request: %Struct.Request{cookies: %{"ckns_atkn" => AuthToken.authorised_beta_access_token()}}
  }
  @struct_with_non_auth_user %Struct{
    request: %Struct.Request{cookies: %{"ckns_atkn" => AuthToken.unauthorised_for_beta_access_token()}}
  }
  @struct_with_malformed_token %Struct{
    request: %Struct.Request{cookies: %{"ckns_atkn" => AuthToken.malformed_access_token()}}
  }

  test "the pipline continues as user is on allow list" do
    assert {:ok,
            %Belfrage.Struct{
              debug: %Belfrage.Struct.Debug{
                pipeline_trail: ["MockTransformer"]
              }
            }} = PersonalisationBeta.call(["MockTransformer"], @struct_with_auth_user)

    assert_received(:mock_transformer_called)
  end

  test "the pipline continues without validating session as user is not on allow list" do
    assert {:ok,
            %Belfrage.Struct{
              debug: %Belfrage.Struct.Debug{
                pipeline_trail: []
              }
            }} = PersonalisationBeta.call(["MockTransformer"], @struct_with_non_auth_user)

    refute_received(:mock_transformer_called)
  end

  test "the pipeline continues without validating session as token is malformed" do
    fun = fn ->
      assert {:ok,
              %Belfrage.Struct{
                debug: %Belfrage.Struct.Debug{
                  pipeline_trail: []
                }
              }} = PersonalisationBeta.call(["MockTransformer"], @struct_with_malformed_token)
    end

    assert capture_log(fun) =~ "Claims could not be peeked in Elixir.Belfrage.Transformers.PersonalisationBeta"
    refute_received(:mock_transformer_called)
  end
end
