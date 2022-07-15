defmodule Belfrage.Clients.HTTP.ErrorTest do
  use ExUnit.Case, async: true
  import ExUnit.CaptureLog
  alias Belfrage.Clients.HTTP

  doctest HTTP.Error

  describe "finch errors" do
    test "implements String.Chars protocol" do
      error = %HTTP.Error{reason: :timeout}
      expected = "%Belfrage.Clients.HTTP.Error{reason: :timeout}"

      assert expected == "#{error}"
    end

    test "timeout" do
      log =
        capture_log(fn ->
          %Mint.TransportError{reason: :timeout}
          |> Belfrage.Clients.HTTP.Error.new()
        end)

      assert log =~ ~s("third_party_reason":"timeout")
      assert log =~ ~s("belfrage_http_reason":"timeout")
    end

    test "pool timeout" do
      log =
        capture_log(fn ->
          Belfrage.Clients.HTTP.Error.new(:exit, {:timeout, {NimblePool, :checkout, [:pid_1]}})
        end)

      assert log =~ ~s("third_party_reason":"exited with reason: {:timeout, {NimblePool, :checkout, [:pid_1]}}")
      assert log =~ ~s("belfrage_http_reason":"pool_timeout")
    end

    test "bad_url_scheme, scheme required" do
      log =
        capture_log(fn ->
          Belfrage.Clients.HTTP.Error.new(%ArgumentError{message: "scheme is required for url: www.example.com"})
        end)

      assert log =~ ~s("third_party_reason":"scheme is required for url: www.example.com")
      assert log =~ ~s("belfrage_http_reason":"bad_url_scheme")
    end

    test "bad_url_scheme, no scheme" do
      log =
        capture_log(fn ->
          Belfrage.Clients.HTTP.Error.new(%ArgumentError{message: "invalid scheme"})
        end)

      assert log =~ ~s("third_party_reason":"invalid scheme")
      assert log =~ ~s("belfrage_http_reason":"bad_url_scheme")
    end

    test "logs error not mapped to Belfrage from finch" do
      log =
        capture_log(fn ->
          Belfrage.Clients.HTTP.Error.new(%Mint.HTTPError{module: Mint.HTTP1, reason: :invalid_header})
        end)

      assert log =~ ~s("third_party_reason":"invalid header")
      assert log =~ ~s("belfrage_http_reason":"nil")
    end

    test "logs error not mapped to Belfrage from mint" do
      log =
        capture_log(fn ->
          %Mint.TransportError{reason: :protocol_not_negotiated}
          |> Belfrage.Clients.HTTP.Error.new()
        end)

      assert log =~ ~s("third_party_reason":"ALPN protocol not negotiated")
      assert log =~ ~s("belfrage_http_reason":"nil")
    end

    test "logs error containing charlist message" do
      log =
        capture_log(fn ->
          Belfrage.Clients.HTTP.Error.new('This is a charlist message.')
        end)

      assert log =~ ~s("third_party_reason":"errored with reason: 'This is a charlist message.'")
      assert log =~ ~s("belfrage_http_reason":"nil")
    end

    test "unexpected error format" do
      log =
        capture_log(fn ->
          Belfrage.Clients.HTTP.Error.new(%{error: :unexpected_error_format})
        end)

      assert log =~ ~s("third_party_reason":"errored with reason: %{error: :unexpected_error_format}")
      assert log =~ ~s("belfrage_http_reason":"nil")
    end
  end
end
