defmodule Belfrage.Clients.HTTP.ErrorTest do
  use ExUnit.Case, async: true
  import ExUnit.CaptureLog
  alias Belfrage.Clients.HTTP

  doctest HTTP.Error

  test "implements String.Chars protocol" do
    error = %HTTP.Error{reason: :timeout}
    expected = "%Belfrage.Clients.HTTP.Error{reason: :timeout}"

    assert expected == "#{error}"
  end

  test "logs known and standardised error" do
    assert capture_log(fn ->
             %MachineGun.Error{reason: :request_timeout}
             |> Belfrage.Clients.HTTP.Error.new()
           end) =~ ~r/\"belfrage_http_reason\":\"timeout\".+\"third_party_reason\":\":request_timeout\"/
  end

  test "logs error unknown to Belfrage" do
    assert capture_log(fn ->
             %MachineGun.Error{reason: :unexpected_reason}
             |> Belfrage.Clients.HTTP.Error.new()
           end) =~ ~r/\"belfrage_http_reason\":null.+\"third_party_reason\":\":unexpected_reason\"/
  end

  test "logs error containing charlist message" do
    assert capture_log(fn ->
             %MachineGun.Error{reason: {:error_reason, 'This is a charlist message.'}}
             |> Belfrage.Clients.HTTP.Error.new()
           end) =~
             ~r/\"belfrage_http_reason\":null.+\"third_party_reason\":\"{:error_reason, 'This is a charlist message.'}\"/
  end
end
