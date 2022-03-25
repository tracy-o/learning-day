defmodule Belfrage.Xray.ParseTraceTest do
  use ExUnit.Case, async: true

  alias Belfrage.Xray.ParseTrace
  alias AwsExRay.Trace

  describe "parse/1 with a valid trace header" do
    test "returns a trace, with valid 2 part header" do
      trace_header = "Root=1-623d5deb-c665a073bf9119f7e042cb54;Sampled=0"

      assert {:ok,
              %Trace{
                root: "1-623d5deb-c665a073bf9119f7e042cb54",
                sampled: false,
                parent: ""
              }} == ParseTrace.parse(trace_header)
    end

    test "returns a trace, with valid 3 part header" do
      trace_header = "Root=1-623d5deb-c665a073bf9119f7e042cb54;Parent=1c5533f5a9918e36;Sampled=0"

      assert {:ok,
              %Trace{
                root: "1-623d5deb-c665a073bf9119f7e042cb54",
                sampled: false,
                parent: "1c5533f5a9918e36"
              }} == ParseTrace.parse(trace_header)
    end
  end

  describe "parse/1 with invalid trace header, returns {:error, :invalid}" do
    test "when ';' misssing from header" do
      trace_header = "Root=1-623d5deb-c665a073bf9119f7e042cb54Parent=1c5533f5a9918e36;Sampled=0"
      assert {:error, :invalid} == ParseTrace.parse(trace_header)
    end

    test "when 'Root' key missing" do
      trace_header = "Parent=1c5533f5a9918e36;Sampled=0"
      assert {:error, :invalid} == ParseTrace.parse(trace_header)
    end

    test "when 'Sampled' key missing" do
      trace_header = "Root=1-623d5deb-c665a073bf9119f7e042cb54;Parent=1c5533f5a9918e36"
      assert {:error, :invalid} == ParseTrace.parse(trace_header)
    end

    test "when '=' is missing" do
      trace_header = "Root1-623d5deb-c665a073bf9119f7e042cb54;Parent=1c5533f5a9918e36;Sampled=0"
      assert {:error, :invalid} == ParseTrace.parse(trace_header)
    end

    test "when using invalid trace character" do
      trace_header = "Root1-623d5deb-c665a073bf9119f7e042cb54;Parent=1c5533f5a9918e36;Sampled=A"
      assert {:error, :invalid} == ParseTrace.parse(trace_header)
    end
  end
end
