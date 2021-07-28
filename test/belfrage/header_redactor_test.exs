defmodule Belfrage.Logging.HeaderRedactorTest do
  use ExUnit.Case

  alias Belfrage.Logging.HeaderRedactor

  describe "redact/1" do
    test "header not on redacted list are not redacted" do
      assert [{"some_header", "value"}] == HeaderRedactor.redact([{"some_header", "value"}], [])
    end

    test "cookie headers are redacted" do
      assert [{"cookie", "REDACTED"}] == HeaderRedactor.redact([{"cookie", "value"}], [])
    end

    test "ssl headers are redacted" do
      assert [{"ssl", "REDACTED"}] == HeaderRedactor.redact([{"ssl", "value"}], [])
    end

    test "content-security-policy headers are redacted" do
      assert [{"content-security-policy", "REDACTED"}] ==
               HeaderRedactor.redact([{"content-security-policy", "value"}], [])
    end

    test "feature-policy headers are redacted" do
      assert [{"feature-policy", "REDACTED"}] == HeaderRedactor.redact([{"feature-policy", "value"}], [])
    end

    test "report-to headers are redacted" do
      assert [{"report-to", "REDACTED"}] == HeaderRedactor.redact([{"report-to", "value"}], [])
    end
  end
end
