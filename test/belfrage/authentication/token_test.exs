defmodule Belfrage.Authentication.TokenTest do
  use ExUnit.Case
  alias Belfrage.Authentication.Token

  alias Fixtures.AuthToken, as: T

  setup do
    start_supervised!(Belfrage.Authentication.Jwk)
    :ok
  end

  describe "parse/1" do
    test "with valid user_attributes access token" do
      assert Token.parse(T.valid_access_token()) == {true, %{age_bracket: "o18", allow_personalisation: true}}
    end

    test "with non existant user_attributes access token" do
      assert Token.parse(T.valid_access_token_without_user_attributes()) == {true, nil}
    end

    test "with invalid access token" do
      assert Token.parse(T.invalid_access_token()) == {false, nil}
    end
  end
end
