defmodule Belfrage.RequestTransformers.PersonalisedAccountOffRedirectTest do
  use ExUnit.Case, async: true
  alias Belfrage.{Envelope}
  alias Belfrage.RequestTransformers.PersonalisedAccountOffRedirect

  test "redirect to /account if allow_personalisation is false" do
    envelope = %Envelope{
      request: %Envelope.Request{
        scheme: :https,
        host: "www.bbc.co.uk",
        path: "/foryou"
      },
      user_session: %Envelope.UserSession{
        user_attributes: %{
          allow_personalisation: false
        }
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
           } = PersonalisedAccountOffRedirect.call(envelope)
  end

  test "redirect to /account if allow_personalisation is nil" do
    envelope = %Envelope{
      request: %Envelope.Request{
        scheme: :https,
        host: "www.bbc.co.uk",
        path: "/foryou"
      },
      user_session: %Envelope.UserSession{
        user_attributes: %{
          allow_personalisation: nil
        }
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
           } = PersonalisedAccountOffRedirect.call(envelope)
  end

  test "redirect to /account if allow_personalisation is undefined" do
    envelope = %Envelope{
      request: %Envelope.Request{
        scheme: :https,
        host: "www.bbc.co.uk",
        path: "/foryou"
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
           } = PersonalisedAccountOffRedirect.call(envelope)
  end

  test "Do not redirect if allow_personalisation is true" do
    envelope = %Envelope{
      request: %Envelope.Request{
        scheme: :https,
        host: "www.bbc.co.uk",
        path: "/foryou"
      },
      user_session: %Envelope.UserSession{
        user_attributes: %{
          allow_personalisation: true
        }
      }
    }

    assert {
             :ok,
             %{
               response: %Envelope.Response{}
             }
           } = PersonalisedAccountOffRedirect.call(envelope)
  end
end
