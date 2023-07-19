defmodule Belfrage.Mvt.AllowlistTest do
  use ExUnit.Case
  import Test.Support.Helper, only: [set_environment: 1]

  alias Belfrage.Envelope
  alias Belfrage.Envelope.{Private, Request}
  alias Belfrage.Processor
  alias Belfrage.Mvt.Allowlist

  describe "bbc-mvt-{i} (where 1 <= i <= 20) headers" do
    test "all bbc-mvt-{i} headers are added to allowlist" do
      envelope =
        build_envelope(
          raw_header: %{
            "bbc-mvt-0" => "experiment;name;some_value",
            "bbc-mvt-1" => "experiment;name;some_value",
            "bbc-mvt-20" => "experiment;name;some_value",
            "bbc-mvt-21" => "experiment;name;some_value"
          },
          mvt_project_id: 1
        )
        |> Allowlist.add()

      refute "bbc-mvt-0" in envelope.private.headers_allowlist
      assert "bbc-mvt-1" in envelope.private.headers_allowlist
      assert "bbc-mvt-20" in envelope.private.headers_allowlist
      refute "bbc-mvt-21" in envelope.private.headers_allowlist
    end

    test "are allowed into envelope.request.raw_headers" do
      envelope =
        build_envelope(
          raw_headers: %{"bbc-mvt-1" => "experiment;name;some_value"},
          mvt_project_id: 1
        )

      raw_headers = Processor.allowlists(envelope).request.raw_headers
      assert Map.has_key?(raw_headers, "bbc-mvt-1")
    end

    test "are not in envelope.request.raw_headers if route_state_id is nil (preflight pipeline failed for multi-platform spec)" do
      envelope =
        build_envelope(
          raw_header: %{"bbc-mvt-1" => "experiment;name;some_value"},
          mvt_project_id: 1,
          route_state_id: nil
        )

      raw_headers = Processor.allowlists(envelope).request.raw_headers
      refute Map.has_key?(raw_headers, "bbc-mvt-1")
    end
  end

  # When a header key has the format 'mvt-*' its considered an override header.
  # Unlike bbc-mvt-{i} headers (where 1 <= i <= 20) any string can be appended
  # after the *. The header value should follow the format "#{type};#{value}"
  # but no checks or transformation are performed.
  # These headers are only valid on test environments.
  describe "mvt override headers in format mvt-* and environment is test" do
    setup do
      set_environment("test")
    end

    test "all mvt-* headers are added to allowlist" do
      envelope =
        build_envelope(
          raw_headers: %{
            "mvt-some_override" => "experiment;name;some_value",
            "mvt-another_override" => "experiment;name;some_value",
            "invalid-override" => "experiment;name;some_value"
          },
          mvt_project_id: 1
        )
        |> Allowlist.add()

      assert "mvt-some_override" in envelope.private.headers_allowlist
      assert "mvt-another_override" in envelope.private.headers_allowlist
      refute "invalid-override" in envelope.private.headers_allowlist
    end

    test "are allowed into envelope.request.raw_headers" do
      override_headers = %{
        "mvt-an_override" => "experiment;some_value",
        "mvt-another_override" => "experiment;another_value"
      }

      envelope = build_envelope(raw_headers: override_headers, mvt_project_id: 1)

      raw_headers = Processor.allowlists(envelope).request.raw_headers
      assert raw_headers == override_headers
    end
  end

  describe "mvt override headers in format mvt-* and environment is live" do
    setup do
      set_environment("live")
    end

    test "none of the headers are added to the allowlist" do
      envelope =
        build_envelope(
          raw_headers: %{
            "mvt-some_override" => "experiment;name;some_value",
            "mvt-another_override" => "experiment;name;some_value",
            "invalid-override" => "experiment;name;some_value"
          },
          mvt_project_id: 1
        )
        |> Allowlist.add()

      refute "mvt-some_override" in envelope.private.headers_allowlist
      refute "mvt-another_override" in envelope.private.headers_allowlist
      refute "invalid-override" in envelope.private.headers_allowlist
    end
  end

  describe "if no mvt_project_id is set and on test" do
    setup do
      set_environment("test")
    end

    test "no bbc-mvt-{i} headers are added" do
      envelope =
        build_envelope(
          raw_headers: %{
            "bbc-mvt-1" => "experiment;name;some_value"
          },
          mvt_project_id: 0
        )
        |> Allowlist.add()

      refute "bbc-mvt-1" in envelope.private.headers_allowlist
    end

    test "override mvt headers are added" do
      envelope =
        build_envelope(
          raw_headers: %{
            "mvt-some_override" => "experiment;name;some_value"
          },
          mvt_project_id: 0
        )
        |> Allowlist.add()

      assert "mvt-some_override" in envelope.private.headers_allowlist
    end
  end

  describe "if no mvt_project_id is set and on live" do
    setup do
      set_environment("live")
    end

    test "no bbc-mvt-{i} headers are added" do
      envelope =
        build_envelope(
          raw_headers: %{
            "bbc-mvt-1" => "experiment;name;some_value"
          },
          mvt_project_id: 0
        )
        |> Allowlist.add()

      refute "bbc-mvt-1" in envelope.private.headers_allowlist
    end

    test "no override mvt headers are added" do
      envelope =
        build_envelope(
          raw_headers: %{
            "mvt-some_override" => "experiment;name;some_value"
          },
          mvt_project_id: 0
        )
        |> Allowlist.add()

      refute "mvt-some_override" in envelope.private.headers_allowlist
    end
  end

  defp build_envelope(opts) do
    raw_headers = Keyword.get(opts, :raw_headers, %{})
    mvt_project_id = Keyword.get(opts, :mvt_project_id, 0)
    route_state_id = Keyword.get(opts, :route_state_id, {"SomeSpec", "SomePlatform"})

    %Envelope{
      private: %Private{
        route_state_id: route_state_id,
        mvt_project_id: mvt_project_id
      },
      request: %Request{
        raw_headers: raw_headers
      }
    }
  end
end
