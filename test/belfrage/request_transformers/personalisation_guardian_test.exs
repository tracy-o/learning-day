defmodule Belfrage.RequestTransformers.PersonalisationGuardianTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.Envelope
  alias Belfrage.Envelope.{Request, Private, UserSession}
  alias Belfrage.RequestTransformers.PersonalisationGuardian

  @token "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IlNPTUVfRUNfS0VZX0lEIn0.eyJzdWIiOiIzNGZlcnIzLWI0NmItNDk4Ni04ZTNjLTVhZjg5ZGZiZTAzZCIsImN0cyI6Ik9BVVRIMl9TVEFURUxFU1NfR1JBTlQiLCJhdXRoX2xldmVsIjowLCJhdWRpdFRyYWNraW5nSWQiOiJncmc2NTk2NS03MjIzLTRiNjctYWY0Mi0zNmYxNDI0MzE3ODMtMjQ0NTA5MzU0IiwiaXNzIjoiaHR0cHM6Ly9hY2Nlc3MuaW50LmFwaS5iYmMuY29tL2JiY2lkdjUvb2F1dGgyIiwidG9rZW5OYW1lIjoiYWNjZXNzX3Rva2VuIiwidG9rZW5fdHlwZSI6IkJlYXJlciIsImF1dGhHcmFudElkIjoiNWdydGFFaWU0eF8xczNnODRyNEQwdXFLQ00iLCJhdWQiOiJBY2NvdW50IiwibmJmIjoxNTkwNjE0MTgzLCJncmFudF90eXBlIjoicmVmcmVzaF90b2tlbiIsInNjb3BlIjpbImV4cGxpY2l0IiwidWlkIiwiaW1wbGljaXQiLCJwaWkiLCJjb3JlIiwib3BlbmlkIl0sImF1dGhfdGltZSI6MTU5MDUwMjc2MCwicmVhbG0iOiIvIiwiZXhwIjoxOTAxNTIxMzgzLCJpYXQiOjE1OTA2MTQxODMsImV4cGlyZXNfaW4iOjMxMDkwNzIwMCwianRpIjoiTjZGaE1WcGdVUnlTaFl1ekhnTHN4VzdsNWRJIiwidXNlckF0dHJpYnV0ZXMiOnsiYWdlQnJhY2tldCI6Im8xOCIsImFsbG93UGVyc29uYWxpc2F0aW9uIjp0cnVlLCJhbmFseXRpY3NIYXNoZWRJZCI6ImdKT0YtOWFJUTYwaVpJcFlhRXlTUVAwSU1JMmdBcmZVVEZMay1sZ0VHVEUifX0.xg4vY41q6X9XlejwUX_8MGADWigvd_xj-wMEn8rnnwaV3FxWhE2gb9NVX3gMEjZJUw4CSwq_-ajd8hhUNXmChw"

  describe "call/2" do
    test "request is not personalised" do
      envelope = %Envelope{
        request: %Request{
          path: "/search",
          scheme: :http,
          host: "bbc.co.uk",
          query_params: %{"q" => "5tr!ctly c0m3 d@nc!nG"}
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
          path: "/search",
          scheme: :http,
          host: "bbc.co.uk",
          query_params: %{"q" => "5tr!ctly c0m3 d@nc!nG"},
          raw_headers: %{"x-id-oidc-signedin" => "0"}
        },
        private: %Private{
          personalised_request: true
        },
        user_session: %UserSession{
          authenticated: false,
          authentication_env: "int",
          session_token: nil,
          user_attributes: %{},
          valid_session: false
        }
      }

      assert {:ok, _envelope} = PersonalisationGuardian.call(envelope)
    end

    test "user is authenticated, web session is invalid" do
      envelope = %Envelope{
        request: %Request{
          path: "/search",
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
          session_token: nil,
          user_attributes: %{},
          valid_session: false
        }
      }

      assert {:stop, envelope} = PersonalisationGuardian.call(envelope)

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

    test "user is authenticated, session is valid" do
      envelope = %Envelope{
        request: %Request{
          path: "/search",
          scheme: :http,
          host: "bbc.co.uk",
          query_params: %{"q" => "5tr!ctly c0m3 d@nc!nG"},
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

      assert {:ok, _envelope} = PersonalisationGuardian.call(envelope)
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

      assert {:ok, _envelope} = PersonalisationGuardian.call(envelope)
    end

    test "app session is authenticated but invalid" do
      envelope = %Envelope{
        request: %Request{
          path: "/search",
          scheme: :http,
          host: "bbc.co.uk",
          query_params: %{"q" => "5tr!ctly c0m3 d@nc!nG"},
          raw_headers: %{"authorization" => "Bearer #{@token}"},
          app?: true
        },
        private: %Private{
          personalised_request: true
        },
        user_session: %UserSession{
          authenticated: true,
          authentication_env: "int",
          session_token: nil,
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
      envelope = %Envelope{
        request: %Request{
          path: "/search",
          scheme: :http,
          host: "bbc.co.uk",
          query_params: %{"q" => "5tr!ctly c0m3 d@nc!nG"},
          raw_headers: %{
            "authorization" => "Bearer #{@token}"
          },
          app?: true
        },
        private: %Private{
          personalised_request: true
        },
        user_session: %UserSession{
          authenticated: true,
          authentication_env: "int",
          session_token: @token,
          user_attributes: %{age_bracket: "o18", allow_personalisation: true},
          valid_session: true
        }
      }

      assert {:ok, _envelope} = PersonalisationGuardian.call(envelope)
    end
  end
end
