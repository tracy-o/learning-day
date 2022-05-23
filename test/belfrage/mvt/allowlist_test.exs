defmodule Belfrage.Mvt.AllowlistTest do
  use ExUnit.Case

  alias Belfrage.Struct
  alias Belfrage.Struct.{Private, Request}
  alias Belfrage.Processor
  alias Belfrage.Mvt.Allowlist

  describe "bbc-mvt-i (where 0 <= i <= 20) headers" do
    test "all bbc-mvt-i headers are added to allowlist" do
      struct =
        %Struct{
          request: %Request{
            raw_headers: %{
              "bbc-mvt-0" => "experiment;name;some_value",
              "bbc-mvt-1" => "experiment;name;some_value",
              "bbc-mvt-20" => "experiment;name;some_value",
              "bbc-mvt-21" => "experiment;name;some_value"
            }
          }
        }
        |> Allowlist.add()

      refute "bbc-mvt-0" in struct.private.headers_allowlist
      assert "bbc-mvt-1" in struct.private.headers_allowlist
      assert "bbc-mvt-20" in struct.private.headers_allowlist
      refute "bbc-mvt-21" in struct.private.headers_allowlist
    end

    test "are allowed into struct.request.raw_headers" do
      mvt_headers = %{"bbc-mvt-1" => "experiment;name;some_value"}

      struct = %Struct{
        request: %Request{
          raw_headers: mvt_headers
        }
      }

      raw_headers = Processor.allowlists(struct).request.raw_headers
      assert Map.has_key?(raw_headers, "bbc-mvt-1")
    end
  end

  describe "mvt override headers in format mvt-*" do
    test "all bbc-mvt-i headers are added to allowlist" do
      struct =
        %Struct{
          request: %Request{
            raw_headers: %{
              "mvt-some_override" => "experiment;name;some_value",
              "mvt-another_override" => "experiment;name;some_value",
              "invalid-override" => "experiment;name;some_value"
            }
          }
        }
        |> Allowlist.add()

      assert "mvt-some_override" in struct.private.headers_allowlist
      assert "mvt-another_override" in struct.private.headers_allowlist
      refute "invalid-override" in struct.private.headers_allowlist
    end

    test "are allowed into struct.request.raw_headers" do
      override_headers = %{
        "mvt-an_override" => "experiment;some_value",
        "mvt-another_override" => "experiment;another_value"
      }

      struct = %Struct{
        request: %Request{
          raw_headers: override_headers
        }
      }

      raw_headers = Processor.allowlists(struct).request.raw_headers
      assert raw_headers == override_headers
    end
  end
end
