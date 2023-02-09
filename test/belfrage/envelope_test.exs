defmodule Belfrage.EnvelopeTest do
  use ExUnit.Case
  alias Belfrage.Envelope

  describe "loggable/1" do
    test "removes response body" do
      assert "REMOVED" == Envelope.loggable(%Envelope{}).response.body
    end

    test "removes request header PII" do
      envelope = %Envelope{request: %Envelope.Request{raw_headers: %{"cookie" => "abc123"}}}
      assert %Envelope{request: %Envelope.Request{raw_headers: [{"cookie", "REDACTED"}]}} = Envelope.loggable(envelope)
    end

    test "removes response header PII" do
      envelope = %Envelope{response: %Envelope.Response{headers: %{"set-cookie" => "abc123"}}}

      assert %Envelope{response: %Envelope.Response{headers: [{"set-cookie", "REDACTED"}]}} =
               Envelope.loggable(envelope)
    end

    test "removes session_token PII" do
      envelope = %Envelope{user_session: %Envelope.UserSession{:session_token => "some-token"}}
      assert %Envelope{user_session: %Envelope.UserSession{:session_token => "REDACTED"}} = Envelope.loggable(envelope)
    end

    test "keeps nil session_token values" do
      envelope = %Envelope{user_session: %Envelope.UserSession{:session_token => nil}}
      assert %Envelope{user_session: %Envelope.UserSession{:session_token => nil}} = Envelope.loggable(envelope)
    end

    test "keeps non-PII request headers" do
      envelope = %Envelope{request: %Envelope.Request{raw_headers: %{"foo" => "bar"}}}
      assert %Envelope{request: %Envelope.Request{raw_headers: [{"foo", "bar"}]}} = Envelope.loggable(envelope)
    end

    test "keeps non-PII response headers" do
      envelope = %Envelope{response: %Envelope.Response{headers: %{"foo" => "bar"}}}
      assert %Envelope{response: %Envelope.Response{headers: [{"foo", "bar"}]}} = Envelope.loggable(envelope)
    end

    test "removes cookies section from envelope.request" do
      envelope = %Envelope{request: %Envelope.Request{cookies: %{"foo" => "bar"}}}

      assert %Envelope{request: %Envelope.Request{cookies: "REMOVED"}} = Envelope.loggable(envelope)
    end
  end
end
