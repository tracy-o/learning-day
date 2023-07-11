defmodule Belfrage.RequestTransformers.PersonalisationGuardianTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.Envelope
  alias Belfrage.Envelope.{Request, Private, UserSession}
  alias Belfrage.RequestTransformers.PersonalisationGuardian

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

      assert PersonalisationGuardian.call(envelope) == {:ok, envelope}
    end

    test "user is not authenticated" do
      envelope = %Envelope{
        request: %Request{
          path: "/sport",
          scheme: :http,
          host: "bbc.co.uk",
          raw_headers: %{"x-id-oidc-signedin" => "0"}
        },
        private: %Private{
          personalised_request: false
        },
        user_session: %UserSession{
          authenticated: false,
          authentication_env: "int",
          session_token: nil,
          user_attributes: %{},
          valid_session: false
        }
      }

      assert {:ok, ^envelope} = PersonalisationGuardian.call(envelope)
    end

    test "user is authenticated, token is invalid" do
      token = Fixtures.AuthToken.invalid_access_token()

      envelope = %Envelope{
        request: %Request{
          path: "/sport",
          scheme: :http,
          host: "bbc.co.uk",
          query_params: %{"q" => "5tr!ctly c0m3 d@nc!nG"},
          raw_headers: %{"x-id-oidc-signedin" => "1"}
        },
        private: %Private{
          personalised_request: true
        },
        user_session: %UserSession{
          authenticated: true,
          authentication_env: "int",
          session_token: token,
          user_attributes: %{},
          valid_session: false
        }
      }

      assert {:stop, envelope} = PersonalisationGuardian.call(envelope)

      assert envelope.response == %Envelope.Response{
               http_status: 302,
               headers: %{
                 "location" =>
                   "https://session.test.bbc.co.uk/session?ptrt=http%3A%2F%2Fbbc.co.uk%2Fsport%3Fq=5tr%21ctly+c0m3+d%40nc%21nG",
                 "x-bbc-no-scheme-rewrite" => "1",
                 "cache-control" => "private"
               },
               body: "Redirecting"
             }
    end

    test "user is authenticated, session is valid" do
      envelope = %Envelope{
        request: %Request{
          path: "/sport",
          scheme: :http,
          host: "bbc.co.uk",
          raw_headers: %{
            "x-id-oidc-signedin" => "1"
          }
        },
        private: %Private{
          personalised_request: true
        },
        user_session: %UserSession{
          authenticated: true,
          authentication_env: "int",
          user_attributes: %{age_bracket: "o18", allow_personalisation: true},
          valid_session: true
        }
      }

      assert {:ok, ^envelope} = PersonalisationGuardian.call(envelope)
    end

    test "app session is not authenticated nor valid" do
      envelope = %Envelope{
        request: %Request{
          path: "/fd/p/mytopics-page",
          scheme: :http,
          host: "news-app.api.bbc.co.uk",
          app?: true
        },
        private: %Private{
          personalised_request: false
        }
      }

      assert {:ok, _envelope} = PersonalisationGuardian.call(envelope)
    end

    test "app session is authenticated but token invalid" do
      token = Fixtures.AuthToken.invalid_access_token()

      envelope = %Envelope{
        request: %Request{
          path: "/fd/p/mytopics-page",
          scheme: :http,
          host: "news-app.api.bbc.co.uk",
          raw_headers: %{"authorization" => "Bearer #{token}"},
          app?: true
        },
        private: %Private{
          personalised_request: true
        },
        user_session: %UserSession{
          authenticated: true,
          authentication_env: "int",
          session_token: token,
          user_attributes: %{},
          valid_session: false
        }
      }

      assert {
               :stop,
               %Belfrage.Envelope{
                 response: %Belfrage.Envelope.Response{
                   http_status: 401
                 }
               }
             } = PersonalisationGuardian.call(envelope)
    end

    test "app session is authenticated and valid" do
      token = Fixtures.AuthToken.valid_access_token()

      envelope = %Envelope{
        request: %Request{
          path: "/fd/p/mytopics-page",
          scheme: :http,
          host: "news-app.api.bbc.co.uk",
          raw_headers: %{
            "authorization" => "Bearer #{token}"
          },
          app?: true
        },
        private: %Private{
          personalised_request: true
        },
        user_session: %UserSession{
          authenticated: true,
          authentication_env: "int",
          session_token: token,
          user_attributes: %{age_bracket: "o18", allow_personalisation: true},
          valid_session: true
        }
      }

      assert {:ok, ^envelope} = PersonalisationGuardian.call(envelope)
    end
  end
end
