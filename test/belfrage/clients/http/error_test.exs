defmodule Belfrage.Clients.HTTP.ErrorTest do
  use ExUnit.Case, async: true
  import ExUnit.CaptureLog
  alias Belfrage.Clients.HTTP

  doctest HTTP.Error

  describe "machine gun errors" do
    test "implements String.Chars protocol" do
      error = %HTTP.Error{reason: :timeout}
      expected = "%Belfrage.Clients.HTTP.Error{reason: :timeout}"

      assert expected == "#{error}"
    end

    test "logs known and standardised error" do
      log =
        capture_log(fn ->
          %MachineGun.Error{reason: :request_timeout}
          |> Belfrage.Clients.HTTP.Error.new()
        end)

      assert log =~ ~s("third_party_reason":":request_timeout")
      assert log =~ ~s("belfrage_http_reason":"timeout")
    end

    test "logs error unknown to Belfrage" do
      log =
        capture_log(fn ->
          %MachineGun.Error{reason: :unexpected_reason}
          |> Belfrage.Clients.HTTP.Error.new()
        end)

      assert log =~ ~s("third_party_reason":":unexpected_reason")
      assert log =~ ~s("belfrage_http_reason":"nil")
    end

    test "logs error containing charlist message" do
      log =
        capture_log(fn ->
          %MachineGun.Error{reason: {:error_reason, 'This is a charlist message.'}}
          |> Belfrage.Clients.HTTP.Error.new()
        end)

      assert log =~ ~s("third_party_reason":"{:error_reason, 'This is a charlist message.'}")
      assert log =~ ~s("belfrage_http_reason":"nil")
    end
  end

  describe "Finch Errors" do
    test "Mint transport options error" do
      log = capture_log(fn -> Belfrage.Clients.HTTP.Error.new(%Mint.TransportError{reason: :timeout}) end)

      assert log =~ ~s("third_party_reason":"timeout")
      assert log =~ ~s("belfrage_http_reason":"not_yet_implemented")
    end

    test "Mint http error" do
      log =
        capture_log(fn ->
          Belfrage.Clients.HTTP.Error.new(%Mint.HTTPError{module: Mint.HTTP1, reason: :invalid_header})
        end)

      assert log =~ ~s("third_party_reason":"invalid header")
      assert log =~ ~s("belfrage_http_reason":"not_yet_implemented")
    end
  end
end
