defmodule Belfrage.Mvt.AllowlistTest do
  use ExUnit.Case

  alias Belfrage.Struct
  alias Belfrage.Struct.{Private, Request}
  alias Belfrage.Processor
  alias Belfrage.Mvt.Allowlist

  describe "bbc-mvt-i (where 0 <= i <= 20) headers" do
    test "all bbc-mvt-i headers are added to allowlist" do
      struct =
        build_struct(
          raw_header: %{
            "bbc-mvt-0" => "experiment;name;some_value",
            "bbc-mvt-1" => "experiment;name;some_value",
            "bbc-mvt-20" => "experiment;name;some_value",
            "bbc-mvt-21" => "experiment;name;some_value"
          },
          mvt_project_id: 1
        )
        |> Allowlist.add()

      refute "bbc-mvt-0" in struct.private.headers_allowlist
      assert "bbc-mvt-1" in struct.private.headers_allowlist
      assert "bbc-mvt-20" in struct.private.headers_allowlist
      refute "bbc-mvt-21" in struct.private.headers_allowlist
    end

    test "are allowed into struct.request.raw_headers" do
      struct =
        build_struct(
          raw_headers: %{"bbc-mvt-1" => "experiment;name;some_value"},
          mvt_project_id: 1
        )

      raw_headers = Processor.allowlists(struct).request.raw_headers
      assert Map.has_key?(raw_headers, "bbc-mvt-1")
    end
  end

  describe "mvt override headers in format mvt-*" do
    test "all bbc-mvt-i headers are added to allowlist" do
      struct =
        build_struct(
          raw_headers: %{
            "mvt-some_override" => "experiment;name;some_value",
            "mvt-another_override" => "experiment;name;some_value",
            "invalid-override" => "experiment;name;some_value"
          },
          mvt_project_id: 1
        )
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

      struct = build_struct(raw_headers: override_headers, mvt_project_id: 1)

      raw_headers = Processor.allowlists(struct).request.raw_headers
      assert raw_headers == override_headers
    end
  end

  def build_struct(opts) do
    raw_headers = Keyword.get(opts, :raw_headers, %{})
    mvt_project_id = Keyword.get(opts, :mvt_project_id, 0)

    %Struct{
      private: %Private{
        mvt_project_id: mvt_project_id
      },
      request: %Request{
        raw_headers: raw_headers
      }
    }
  end
end
