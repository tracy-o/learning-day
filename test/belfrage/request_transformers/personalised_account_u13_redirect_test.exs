defmodule Belfrage.RequestTransformers.PersonalisedAccountU13RedirectTest do
  use ExUnit.Case, async: true
  alias Belfrage.{Envelope}
  alias Belfrage.RequestTransformers.PersonalisedAccountU13Redirect

  test "redirect to /account if age_bracket is u13" do
    envelope = %Envelope{
      request: %Envelope.Request{
        scheme: :https,
        host: "www.bbc.co.uk",
        path: "/foryou"
      },
      user_session: %Envelope.UserSession{
        user_attributes: %{
          age_bracket: "u13"
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
           } = PersonalisedAccountU13Redirect.call(envelope)
  end

  test "redirect to /account if age_bracket is nil" do
    envelope = %Envelope{
      request: %Envelope.Request{
        scheme: :https,
        host: "www.bbc.co.uk",
        path: "/foryou"
      },
      user_session: %Envelope.UserSession{
        user_attributes: %{
          age_bracket: nil
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
           } = PersonalisedAccountU13Redirect.call(envelope)
  end

  test "redirect to /account if age_bracket is undefined" do
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
           } = PersonalisedAccountU13Redirect.call(envelope)
  end

  test "Do not redirect if age_bracket is not u13, nil, or undefined" do
    envelope = %Envelope{
      request: %Envelope.Request{
        scheme: :https,
        host: "www.bbc.co.uk"
      },
      user_session: %Envelope.UserSession{
        user_attributes: %{
          age_bracket: "o18"
        }
      }
    }

    assert {
             :ok,
             %{
               response: %Envelope.Response{}
             }
           } = PersonalisedAccountU13Redirect.call(envelope)
  end
end
