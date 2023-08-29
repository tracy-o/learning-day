defmodule Belfrage.Authentication.TokenTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox
  import ExUnit.CaptureLog
  import Belfrage.Test.MetricsHelper
  alias Belfrage.Authentication.Token
  alias Fixtures.AuthToken, as: T

  describe "parse/1" do
    test "with valid user_attributes access token" do
      assert Token.parse(T.valid_access_token()) == {true, %{age_bracket: "o18", allow_personalisation: true}}
    end

    test "with ckns_atkn token with profile_admin_id" do
      assert Token.parse(T.valid_access_token_profile_admin_id()) ==
               {true,
                %{
                  age_bracket: "u13",
                  allow_personalisation: true,
                  profile_admin_id: "7d125f68-e4e0-462b-9bd3-473fd821db99"
                }}
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
      assert Token.parse(T.invalid_key_token()) == {false, %{}}
    end

    test "warn logged when public key not found" do
      refute capture_log([level: :error], fn ->
               Token.parse(T.invalid_key_token())
             end) =~ ~s(Public key not found)

      assert capture_log([level: :warn], fn ->
               Token.parse(T.invalid_key_token())
             end) =~ ~s(Public key not found)
    end

    test "event sent when public key not found" do
      assert_metric([:request, :public_key_not_found], fn ->
        Token.parse(T.invalid_key_token())
      end)
    end

    test "metric sent when public key not found" do
      {socket, port} = given_udp_port_opened()

      start_reporter(
        metrics: Belfrage.Metrics.Statsd.statix_static_metrics(),
        formatter: :datadog,
        global_tags: [BBCEnvironment: "live"],
        port: port
      )

      Token.parse(T.invalid_key_token())

      assert_reported(
        socket,
        "belfrage.request.public_key_not_found:1|c|#BBCEnvironment:live"
      )
    end
  end
end
