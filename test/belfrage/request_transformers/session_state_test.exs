defmodule Belfrage.RequestTransformers.SessionStateTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  import Belfrage.Test.PersonalisationHelper

  alias Belfrage.Envelope
  alias Belfrage.Envelope.{Request, Private}
  alias Belfrage.RequestTransformers.SessionState

  setup do
    envelope =
      %Envelope{
        request: %Request{
          path: "/sport",
          scheme: :http,
          host: "bbc.co.uk"
        },
        private: %Private{
          personalised_request: true
        }
      }
      |> authenticate_request()


    %{envelope: envelope}
  end

  describe "call/2" do
    test "request is not personalised", %{envelope: envelope} do
      envelope = Envelope.add(envelope, :private, %{personalised_request: false})
      assert SessionState.call(envelope) == {:ok, envelope}
    end

    test "user is authenticated, session is valid", %{envelope: envelope} do
      token = Fixtures.AuthToken.valid_access_token()
      envelope = personalise_request(envelope, token)

      assert {:ok, envelope} = SessionState.call(envelope)
      assert envelope.user_session.authenticated
      assert envelope.user_session.valid_session
      assert envelope.user_session.session_token == token
    end

    test "user is not authenticated", %{envelope: envelope} do
      envelope = deauthenticate_request(envelope)
      assert {:ok, envelope} = SessionState.call(envelope)
      refute envelope.user_session.authenticated
    end

   
    test "user is authenticated, web session is invalid", %{envelope: envelope} do
      assert {:ok, envelope} = SessionState.call(envelope)
      assert envelope.user_session.authenticated
      refute envelope.user_session.valid_session
    end
  end
end
