defmodule Belfrage.RequestTransformers.PersonalisedAccountIsLoggedInTest do
  use ExUnit.Case, async: true
  alias Belfrage.Envelope
  alias Belfrage.RequestTransformers.PersonalisedAccountIsLoggedIn

  test "redirect to /session if not authenticated" do
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
                   "location" => "https://session.bbc.co.uk/session?ptrt=https%3A%2F%2Fwww.bbc.co.uk%2Fforyou",
                   "x-bbc-no-scheme-rewrite" => "1",
                   "cache-control" => "public, stale-if-error=90, stale-while-revalidate=30, max-age=60"
                 }
               }
             }
           } = PersonalisedAccountIsLoggedIn.call(envelope)
  end

  test "redirect to session.test.bbc.co.uk/session env with test prtrt if host is in test env and user is not authenticated" do
    envelope = %Envelope{
      request: %Envelope.Request{
        scheme: :https,
        host: "www.test.bbc.co.uk",
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
                   "location" =>
                     "https://session.test.bbc.co.uk/session?ptrt=https%3A%2F%2Fwww.test.bbc.co.uk%2Fforyou",
                   "x-bbc-no-scheme-rewrite" => "1",
                   "cache-control" => "public, stale-if-error=90, stale-while-revalidate=30, max-age=60"
                 }
               }
             }
           } = PersonalisedAccountIsLoggedIn.call(envelope)
  end

  test "redirect to /signin if there is no user_session" do
    envelope = %Envelope{
      request: %Envelope.Request{
        scheme: :https,
        host: "www.bbc.co.uk",
        path: "/foryou",
        is_uk: true
      }
    }

    assert {
             :stop,
             %{
               response: %{
                 http_status: 302,
                 body: "",
                 headers: %{
                   "location" => "https://session.bbc.co.uk/session?ptrt=https%3A%2F%2Fwww.bbc.co.uk%2Fforyou",
                   "x-bbc-no-scheme-rewrite" => "1",
                   "cache-control" => "public, stale-if-error=90, stale-while-revalidate=30, max-age=60"
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
