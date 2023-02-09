defmodule Belfrage.Allowlist.HeadersTest do
  use ExUnit.Case, async: true
  alias Belfrage.Envelope
  alias Belfrage.Allowlist.Headers

  test "allows all headers when allowlist is *" do
    envelope =
      %Envelope{}
      |> Envelope.add(:request, %{
        raw_headers: %{
          "a" => "b",
          "c" => "d"
        }
      })
      |> Envelope.add(:private, %{
        headers_allowlist: "*"
      })

    assert %{
             "a" => "b",
             "c" => "d"
           } == Headers.filter(envelope).request.raw_headers
  end

  test "rejects all headers when allowlist is empty" do
    envelope =
      %Envelope{}
      |> Envelope.add(:request, %{
        raw_headers: %{
          "a" => "b",
          "c" => "d"
        }
      })
      |> Envelope.add(:private, %{
        headers_allowlist: []
      })

    assert %{} == Headers.filter(envelope).request.raw_headers
  end

  test "filters headers when allowlist is not empty" do
    envelope =
      %Envelope{}
      |> Envelope.add(:request, %{
        raw_headers: %{
          "a" => "b",
          "c" => "d"
        }
      })
      |> Envelope.add(:private, %{
        headers_allowlist: ["a"]
      })

    assert %{
             "a" => "b"
           } == Headers.filter(envelope).request.raw_headers
  end

  test "allowlist in envelope defaults to empty" do
    assert %Envelope{private: %Envelope.Private{headers_allowlist: []}} = %Envelope{}
  end
end
