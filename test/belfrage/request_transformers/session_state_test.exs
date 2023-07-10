defmodule Belfrage.RequestTransformers.SessionStateTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.Envelope
  alias Belfrage.Envelope.{Request, Private}
  alias Belfrage.RequestTransformers.SessionState

  describe "call/2" do
    test "request is not personalised" do
      envelope = %Envelope{
        request: %Request{
          path: "/sport",
          scheme: :http,
          host: "bbc.co.uk"
        },
        private: %Private{
          personalised_request: false
        }
      }

      assert SessionState.call(envelope) == {:ok, envelope}
    end

    test "user is authenticated, session is valid" do
      token = Fixtures.AuthToken.valid_access_token()

      envelope = %Envelope{
        request: %Request{
          path: "/search",
          scheme: :http,
          host: "bbc.co.uk",
          query_params: %{"q" => "5tr!ctly c0m3 d@nc!nG"},
          raw_headers: %{
            "x-id-oidc-signedin" => "1"
          },
          cookies: %{"ckns_atkn" => token}
        },
        private: %Private{
          personalised_request: true
        }
      }

      assert {:ok, envelope} = SessionState.call(envelope)
      assert envelope.user_session.authenticated
      assert envelope.user_session.valid_session
      assert envelope.user_session.session_token == token
    end

    test "user is not authenticated" do
      token = Fixtures.AuthToken.valid_access_token()

      envelope = %Envelope{
        request: %Request{
          path: "/search",
          scheme: :http,
          host: "bbc.co.uk",
          query_params: %{"q" => "5tr!ctly c0m3 d@nc!nG"},
          raw_headers: %{
            "x-id-oidc-signedin" => "0"
          },
          cookies: %{"ckns_atkn" => token}
        },
        private: %Private{
          personalised_request: true
        }
      }

      assert {:ok, envelope} = SessionState.call(envelope)
      refute envelope.user_session.authenticated
    end

    test "user is authenticated, web session is invalid" do
      envelope = %Envelope{
        request: %Request{
          path: "/search",
          scheme: :http,
          host: "bbc.co.uk",
          query_params: %{"q" => "5tr!ctly c0m3 d@nc!nG"},
          raw_headers: %{
            "x-id-oidc-signedin" => "1"
          },
          cookies: %{"ckns_atkn" => "foo"}
        },
        private: %Private{
          personalised_request: true
        }
      }

      assert {:ok, envelope} = SessionState.call(envelope)
      assert envelope.user_session.authenticated
      refute envelope.user_session.valid_session
    end
  end
end
