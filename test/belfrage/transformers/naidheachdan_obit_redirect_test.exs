defmodule Belfrage.Transformers.NaidheachdanObitRedirectTest do
  use ExUnit.Case, async: true
  use Test.Support.Helper, :mox

  alias Belfrage.Transformers.NaidheachdanObitRedirect
  alias Belfrage.Struct

  def enable_obit_mode_dial() do
    stub(Belfrage.Dials.ServerMock, :state, fn :obit_mode ->
      Belfrage.Dials.ObitMode.transform("on")
    end)
  end

  def disable_obit_mode_dial() do
    stub(Belfrage.Dials.ServerMock, :state, fn :obit_mode ->
      Belfrage.Dials.ObitMode.transform("off")
    end)
  end

  @naidheachdan_request_struct %Struct{
    private: %Struct.Private{origin: "https://www.bbc.com"},
    request: %Struct.Request{
      host: "www.bbc.com",
      path: "/naidheachdan",
      scheme: :https
    }
  }

  describe "obit enabled" do
    test "/naidheachdan is redirected /news" do
      enable_obit_mode_dial()

      assert {
               :redirect,
               %Belfrage.Struct{
                 response: %Belfrage.Struct.Response{
                   http_status: 302,
                   body: "Redirecting",
                   headers: %{
                     "location" => "https://www.bbc.com/news",
                     "x-bbc-no-scheme-rewrite" => "1",
                     "cache-control" => "public, stale-while-revalidate=10, max-age=60"
                   }
                 }
               }
             } = NaidheachdanObitRedirect.call([], @naidheachdan_request_struct)
    end
  end

  describe "obit disabled" do
    test "/naidheachdan is not redirected /news" do
      disable_obit_mode_dial()

      assert {
               :ok,
               @naidheachdan_request_struct
             } = NaidheachdanObitRedirect.call([], @naidheachdan_request_struct)
    end
  end
end
