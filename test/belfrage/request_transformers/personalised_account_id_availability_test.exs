defmodule Belfrage.RequestTransformers.PersonalisedAccountIdAvailabilityTest do
  use ExUnit.Case
  alias Belfrage.{Envelope}
  alias Belfrage.RequestTransformers.PersonalisedAccountIdAvailability
  alias Belfrage.Authentication.BBCID
  import Belfrage.Test.PersonalisationHelper

  @default_bbcid_state %{
    id_availability: true,
    foryou_flagpole: false,
    foryou_access_chance: 0,
    foryou_allowlist: []
  }

  setup :reset_bbc_id_on_exit

  test "do not redirect to /account if id-availability is true" do
    Agent.update(BBCID, fn _state -> %{@default_bbcid_state | id_availability: true} end)

    envelope = %Envelope{
      request: %Envelope.Request{
        scheme: :https,
        host: "www.bbc.co.uk",
        path: "/foryou"
      },
      user_session: %Envelope.UserSession{
        user_attributes: %{}
      }
    }

    assert {
             :ok,
             ^envelope
           } = PersonalisedAccountIdAvailability.call(envelope)
  end

  test "redirect to /account if id-availability is false" do
    Agent.update(BBCID, fn _state -> %{@default_bbcid_state | id_availability: false} end)

    envelope = %Envelope{
      request: %Envelope.Request{
        scheme: :https,
        host: "www.bbc.co.uk",
        path: "/foryou"
      },
      user_session: %Envelope.UserSession{
        user_attributes: %{}
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
           } = PersonalisedAccountIdAvailability.call(envelope)
  end
end
