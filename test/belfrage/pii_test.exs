defmodule Belfrage.PIITest do
  use ExUnit.Case

  alias Belfrage.PII

  describe "clean/1" do
    test "non PII headers are not redacted" do
      assert [{"some_header", "value"}] == PII.clean([{"some_header", "value"}], [])
    end

    test "cookie headers are redacted" do
      assert [{"cookie", "REDACTED"}] == PII.clean([{"cookie", "value"}], [])
    end

    test "ssl headers are redacted" do
      assert [{"ssl", "REDACTED"}] == PII.clean([{"ssl", "value"}], [])
    end
  end
end
