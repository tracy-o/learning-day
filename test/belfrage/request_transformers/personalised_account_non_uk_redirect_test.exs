defmodule Belfrage.RequestTransformers.PersonalisedAccountNonUkRedirectTest do
  use ExUnit.Case, async: true
  alias Belfrage.Envelope
  alias Belfrage.RequestTransformers.PersonalisedAccountNonUkRedirect

  test "redirect to /account if not in uk" do
    envelope = %Envelope{
      request: %Envelope.Request{
        scheme: :https,
        host: "www.bbc.co.uk",
        path: "/foryou",
        is_uk: false
      }
    }

    assert {
             :stop,
             %{
               response: %{
                 http_status: 302,
                 body: "",
                 headers: %{
                   "location" => "https://www.bbc.co.uk/account",
                   "x-bbc-no-scheme-rewrite" => "1",
                   "cache-control" => "private, max-age=0"
                 }
               }
             }
           } = PersonalisedAccountNonUkRedirect.call(envelope)
  end

  test "pass if uk" do
    envelope = %Envelope{
      request: %Envelope.Request{
        scheme: :https,
        host: "www.bbc.co.uk",
        path: "/foryou",
        is_uk: true
      }
    }

    assert {:ok, ^envelope} = PersonalisedAccountNonUkRedirect.call(envelope)
  end
end
