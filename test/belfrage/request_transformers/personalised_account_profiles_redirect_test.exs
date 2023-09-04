defmodule Belfrage.RequestTransformers.PersonalisedAccountProfilesRedirectTest do
  use ExUnit.Case, async: true
  alias Belfrage.{Envelope}
  alias Belfrage.RequestTransformers.PersonalisedAccountProfilesRedirect

  test "redirect to /account if user has profile_admin_id" do
    envelope = %Envelope{
      request: %Envelope.Request{
        scheme: :https,
        host: "www.bbc.co.uk",
        path: "/foryou"
      },
      user_session: %Envelope.UserSession{
        user_attributes: %{
          allow_personalisation: false,
          profile_admin_id: "12345"
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
           } = PersonalisedAccountProfilesRedirect.call(envelope)
  end

  test "Proceed if user has no profile_admin_id" do
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

    assert {:ok, ^envelope} = PersonalisedAccountProfilesRedirect.call(envelope)
  end

  test "Proceed without error if user_attributes are undefined" do
    envelope = %Envelope{
      request: %Envelope.Request{
        scheme: :https,
        host: "www.bbc.co.uk",
        path: "/foryou"
      }
    }

    assert {:ok, ^envelope} = PersonalisedAccountProfilesRedirect.call(envelope)
  end
end
