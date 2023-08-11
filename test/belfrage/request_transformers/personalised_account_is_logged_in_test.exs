defmodule Belfrage.RequestTransformers.PersonalisedAccountIsLoggedInTest do
  use ExUnit.Case, async: true
  alias Belfrage.Envelope
  alias Belfrage.RequestTransformers.PersonalisedAccountIsLoggedIn

  test "redirect to /signin if not authenticated" do
    envelope = %Envelope{
      request: %Envelope.Request{
        scheme: :https,
        host: "www.bbc.co.uk",
        path: "/foryou",
        is_uk: true
      },
      user_session: %Envelope.UserSession{
        authenticated: false
      }
    }

    assert {
             :stop,
             %{
               response: %{
                 http_status: 302,
                 body: "",
                 headers: %{
                   "location" => "https://www.bbc.co.uk/signin",
                   "x-bbc-no-scheme-rewrite" => "1",
                   "cache-control" => "private, max-age=0"
                 }
               }
             }
           } = PersonalisedAccountIsLoggedIn.call(envelope)
  end

  test "pass if authenticated" do
    envelope = %Envelope{
      request: %Envelope.Request{
        scheme: :https,
        host: "www.bbc.co.uk",
        path: "/foryou",
        is_uk: true
      },
      user_session: %Envelope.UserSession{
        authenticated: true
      }
    }

    assert {:ok, ^envelope} = PersonalisedAccountIsLoggedIn.call(envelope)
  end
end
