defmodule Belfrage.RequestTransformers.BBCXAuthTest do
  use ExUnit.Case, async: true
  use Test.Support.Helper, :mox

  alias Belfrage.RequestTransformers.BBCXAuth
  alias Belfrage.Envelope

  describe "Basic Authorization logic" do
    test "adds the TEST authorization header to the raw headers" do
      envelope = %Envelope{
        request: %Envelope.Request{raw_headers: %{"header1" => "header1value"}},
        private: %Envelope.Private{production_environment: "test"}
      }

      {:ok, envelope} = BBCXAuth.call(envelope)

      assert envelope.request.raw_headers == %{
               "header1" => "header1value",
               "authorization" => "Basic YmJjeDpjaWhXaHgyV0FhUXJNU1VhdzFOOUIwdHE="
             }
    end

    test "adds the LIVE authorization header to the raw headers" do
      envelope = %Envelope{
        request: %Envelope.Request{raw_headers: %{"header1" => "header1value"}},
        private: %Envelope.Private{production_environment: "live"}
      }

      {:ok, envelope} = BBCXAuth.call(envelope)

      assert envelope.request.raw_headers == %{
               "header1" => "header1value",
               "authorization" => "Basic YmJjeDpyZWZvcmVzdC1kaXNsaWtlLWNvbW1pdA=="
             }
    end
  end
end
