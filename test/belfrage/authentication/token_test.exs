defmodule Belfrage.Authentication.TokenTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox
  import ExUnit.CaptureLog

  alias Belfrage.Authentication.Token
  alias Fixtures.AuthToken, as: T

  describe "parse/1" do
    test "with valid user_attributes access token" do
      assert Token.parse(T.valid_access_token()) == {true, %{age_bracket: "o18", allow_personalisation: true}}
    end

    test "with non existant user_attributes access token" do
      assert Token.parse(T.valid_access_token_without_user_attributes()) == {true, %{}}
    end

    test "invalid access tokens" do
      assert Token.parse(T.invalid_access_token()) == {false, %{}}
      assert Token.parse(T.invalid_payload_access_token()) == {false, %{}}
      assert Token.parse(T.expired_access_token()) == {false, %{}}
      assert Token.parse(T.malformed_access_token()) == {false, %{}}
    end

    test "invalid scope access token" do
      # TODO: This behviour to be confirmed with account team.
      assert Token.parse(T.invalid_scope_access_token()) == {true, %{}}
    end

    test "nearly expired access token" do
      stub(Belfrage.Authentication.Validator.ExpiryMock, :valid?, fn _threshold, _expiry ->
        false
      end)

      assert Token.parse(T.valid_access_token()) == {false, %{}}
    end

    test "invalid token header" do
      log =
        capture_log(fn ->
          assert Token.parse(T.invalid_access_token_header()) == {false, %{}}
        end)

      assert log =~ ~s(Invalid token header)
    end

    test "invalid token name" do
      log =
        capture_log(fn ->
          assert Token.parse(T.invalid_token_name()) == {false, %{}}
        end)

      assert log =~ ~s("claim":"tokenName")
      assert log =~ ~s(Claim validation failed)
    end

    test "no public key" do
      log =
        capture_log(fn ->
          assert Token.parse(T.invalid_key_token()) == {false, %{}}
        end)

      assert log =~ ~s(Public key not found)
    end
  end
end
