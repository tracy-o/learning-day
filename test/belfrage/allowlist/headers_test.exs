defmodule Belfrage.Allowlist.HeadersTest do
  use ExUnit.Case
  alias Belfrage.Struct
  alias Belfrage.Allowlist.Headers

  test "allows all headers when allowlist is *" do
    struct =
      %Struct{}
      |> Struct.add(:request, %{
        raw_headers: %{
          "a" => "b",
          "c" => "d"
        }
      })
      |> Struct.add(:private, %{
        headers_allowlist: "*"
      })

    assert %{
             "a" => "b",
             "c" => "d"
           } == Headers.filter(struct).request.raw_headers
  end

  test "rejects all headers when allowlist is empty" do
    struct =
      %Struct{}
      |> Struct.add(:request, %{
        raw_headers: %{
          "a" => "b",
          "c" => "d"
        }
      })
      |> Struct.add(:private, %{
        headers_allowlist: []
      })

    assert %{} == Headers.filter(struct).request.raw_headers
  end

  test "filters headers when allowlist is not empty" do
    struct =
      %Struct{}
      |> Struct.add(:request, %{
        raw_headers: %{
          "a" => "b",
          "c" => "d"
        }
      })
      |> Struct.add(:private, %{
        headers_allowlist: ["a"]
      })

    assert %{
             "a" => "b"
           } == Headers.filter(struct).request.raw_headers
  end

  test "allowlist in struct defaults to empty" do
    assert %Struct{private: %Struct.Private{headers_allowlist: []}} = %Struct{}
  end
end
