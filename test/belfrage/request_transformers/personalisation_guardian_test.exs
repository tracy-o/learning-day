defmodule Belfrage.RequestTransformers.PersonalisationGuardianTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  import Belfrage.Test.PersonalisationHelper

  alias Belfrage.Envelope
  alias Belfrage.Envelope.{Request, Private}
  alias Belfrage.RequestTransformers.SessionState
  alias Belfrage.RequestTransformers.PersonalisationGuardian

  setup do
    envelope =
      %Envelope{
        request: %Request{
          path: "/search",
          scheme: :http,
          host: "bbc.co.uk",
          query_params: %{"q" => "5tr!ctly c0m3 d@nc!nG"}
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
      assert PersonalisationGuardian.call(envelope) == {:ok, envelope}
    end

    # test "user is not authenticated", %{envelope: envelope} do
    #   envelope = deauthenticate_request(envelope)
    #   assert {:ok, envelope} = PersonalisationGuardian.call(envelope)
    #   refute envelope.user_session.authenticated
    # end

    test "user is authenticated, web session is invalid", %{envelope: envelope} do
      {:ok, envelope} = SessionState.call(envelope)

      assert {:stop, envelope} = PersonalisationGuardian.call(envelope)
      assert envelope.user_session.authenticated
      refute envelope.user_session.valid_session

      assert envelope.response == %Envelope.Response{
               http_status: 302,
               headers: %{
                 "location" =>
                   "https://session.test.bbc.co.uk/session?ptrt=http%3A%2F%2Fbbc.co.uk%2Fsearch%3Fq=5tr%21ctly+c0m3+d%40nc%21nG",
                 "x-bbc-no-scheme-rewrite" => "1",
                 "cache-control" => "private"
               },
               body: "Redirecting"
             }
    end

    test "user is authenticated, session is valid", %{envelope: envelope} do
      token = Fixtures.AuthToken.valid_access_token()
      envelope = personalise_request(envelope, token)
      {:ok, envelope} = SessionState.call(envelope)

      assert {:ok, envelope} = PersonalisationGuardian.call(envelope)
      assert envelope.user_session.authenticated
      assert envelope.user_session.valid_session
      assert envelope.user_session.session_token == token
    end

    test "app session is not authenticated nor valid" do
      envelope = %Envelope{
        request: %Request{
          path: "/search",
          scheme: :http,
          host: "bbc.co.uk",
          query_params: %{"q" => "5tr!ctly c0m3 d@nc!nG"},
          app?: true
        },
        private: %Private{
          personalised_request: true
        }
      }

      assert {:ok, envelope} = PersonalisationGuardian.call(envelope)

      refute envelope.user_session.authenticated
      refute envelope.user_session.valid_session
    end

    test "app session is authenticated but invalid" do
      envelope = %Envelope{
        request: %Request{
          path: "/search",
          scheme: :http,
          host: "bbc.co.uk",
          query_params: %{"q" => "5tr!ctly c0m3 d@nc!nG"},
          raw_headers: %{"authorization" => "Bearer some-token"},
          app?: true
        },
        private: %Private{
          personalised_request: true
        }
      }

      {:ok, envelope} = SessionState.call(envelope)

      assert {
               :stop,
               envelope = %Belfrage.Envelope{
                 response: %Belfrage.Envelope.Response{
                   http_status: 401
                 }
               }
             } = PersonalisationGuardian.call(envelope)

      assert envelope.user_session.authenticated
      refute envelope.user_session.valid_session
    end

    test "app session is authenticated and valid" do
      token = Fixtures.AuthToken.valid_access_token()

      envelope = %Envelope{
        request: %Request{
          path: "/search",
          scheme: :http,
          host: "bbc.co.uk",
          query_params: %{"q" => "5tr!ctly c0m3 d@nc!nG"},
          raw_headers: %{"authorization" => "Bearer #{token}"},
          app?: true
        },
        private: %Private{
          personalised_request: true
        }
      }

      {:ok, envelope} = SessionState.call(envelope)

      assert {:ok, envelope} = PersonalisationGuardian.call(envelope)

      assert envelope.user_session.authenticated
      assert envelope.user_session.valid_session
      assert envelope.user_session.session_token == token
    end
  end
end
