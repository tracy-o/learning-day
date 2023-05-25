defmodule Belfrage.RequestTransformers.BBCXAuthTest do
  use ExUnit.Case, async: true
  use Test.Support.Helper, :mox

  alias Belfrage.RequestTransformers.BBCXAuth
  alias Belfrage.Envelope

  @envelope %Envelope{
    request: %Envelope.Request{
      raw_headers: %{"header1" => "header1value"}
    }
  }

  describe "Basic Authorization logic" do
    test "adds the authorization header to the raw headers" do
      {:ok, envelope} = BBCXAuth.call(@envelope)

      assert envelope.request.raw_headers == %{
               "header1" => "header1value",
               "authorization" => "Basic YmJjeDpjaWhXaHgyV0FhUXJNU1VhdzFOOUIwdHE="
             }
    end
  end
end
