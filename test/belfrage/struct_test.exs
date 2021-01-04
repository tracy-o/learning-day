defmodule Belfrage.StructTest do
  use ExUnit.Case
  alias Belfrage.Struct

  describe "loggable/1" do
    test "removes response body" do
      assert "REMOVED" == Struct.loggable(%Struct{}).response.body
    end

    test "removes request header PII" do
      struct = %Struct{request: %Struct.Request{raw_headers: %{"cookie" => "abc123"}}}
      assert %Struct{request: %Struct.Request{raw_headers: [{"cookie", "REDACTED"}]}} = Struct.loggable(struct)
    end

    test "removes response header PII" do
      struct = %Struct{response: %Struct.Response{headers: %{"set-cookie" => "abc123"}}}
      assert %Struct{response: %Struct.Response{headers: [{"set-cookie", "REDACTED"}]}} = Struct.loggable(struct)
    end

    test "removes session_token PII" do
      struct = %Struct{private: %Struct.Private{:session_token => "some-token"}}
      assert %Struct{private: %Struct.Private{:session_token => "REDACTED"}} = Struct.loggable(struct)
    end

    test "keeps nil session_token values" do
      struct = %Struct{private: %Struct.Private{:session_token => nil}}
      assert %Struct{private: %Struct.Private{:session_token => nil}} = Struct.loggable(struct)
    end

    test "keeps non-PII request headers" do
      struct = %Struct{request: %Struct.Request{raw_headers: %{"foo" => "bar"}}}
      assert %Struct{request: %Struct.Request{raw_headers: [{"foo", "bar"}]}} = Struct.loggable(struct)
    end

    test "keeps non-PII response headers" do
      struct = %Struct{response: %Struct.Response{headers: %{"foo" => "bar"}}}
      assert %Struct{response: %Struct.Response{headers: [{"foo", "bar"}]}} = Struct.loggable(struct)
    end

    test "removes cookies section from struct.request" do
      struct = %Struct{request: %Struct.Request{cookies: %{"foo" => "bar"}}}

      assert %Struct{request: %Struct.Request{cookies: "REMOVED"}} = Struct.loggable(struct)
    end
  end
end
