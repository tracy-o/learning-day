defmodule Belfrage.Services.Webcore.RequestTest do
  use ExUnit.Case
  alias Belfrage.Services.Webcore.Request
  alias Belfrage.Envelope

  setup do
    private_valid_session = %Envelope.UserSession{
      authentication_env: "int",
      session_token: "a-valid-session-token",
      authenticated: true,
      valid_session: true,
      user_attributes: %{age_bracket: "o18", allow_personalisation: true}
    }

    private_valid_session_without_user_attributes = %Envelope.UserSession{
      authentication_env: "int",
      session_token: "a-valid-session-token",
      authenticated: true,
      valid_session: true,
      user_attributes: %{}
    }

    private_valid_session_with_partial_user_attributes = %Envelope.UserSession{
      authentication_env: "int",
      session_token: "a-valid-session-token",
      authenticated: true,
      valid_session: true,
      user_attributes: %{allow_personalisation: true}
    }

    private_invalid_session = %Envelope.UserSession{
      authentication_env: "int",
      session_token: "an-invalid-session-token",
      authenticated: true,
      valid_session: false,
      user_attributes: %{}
    }

    private_unauthenticated_session = %Envelope.UserSession{
      authentication_env: "int",
      session_token: nil,
      authenticated: false,
      valid_session: false,
      user_attributes: %{}
    }

    request_envelope = %Envelope{
      request: %Envelope.Request{
        scheme: :https,
        host: "bbc.co.uk",
        path: "/_web_core/12345",
        path_params: %{
          "id" => "12345"
        },
        query_params: %{
          "q" => "something"
        }
      },
      private: %Envelope.Private{
        route_state_id: "HomePage"
      }
    }

    %{
      valid_session: Envelope.add(request_envelope, :user_session, private_valid_session),
      valid_session_without_user_attributes:
        Envelope.add(request_envelope, :user_session, private_valid_session_without_user_attributes),
      valid_session_with_partial_user_attributes:
        Envelope.add(request_envelope, :user_session, private_valid_session_with_partial_user_attributes),
      invalid_session: Envelope.add(request_envelope, :user_session, private_invalid_session),
      unauthenticated_session: Envelope.add(request_envelope, :user_session, private_unauthenticated_session)
    }
  end

  test "builds a non-personalised request", %{unauthenticated_session: envelope} do
    assert %{
             body: nil,
             headers: %{
               "accept-encoding": "gzip",
               country: nil,
               host: "bbc.co.uk",
               is_uk: nil,
               language: nil,
               "ctx-route-spec": "HomePage"
             },
             httpMethod: nil,
             path: "/_web_core/12345",
             pathParameters: %{
               "id" => "12345"
             },
             queryStringParameters: %{"q" => "something"}
           } == Request.build(envelope)
  end

  test "when session is invalid", %{invalid_session: envelope} do
    assert %{
             body: nil,
             headers: %{
               "accept-encoding": "gzip",
               country: nil,
               host: "bbc.co.uk",
               is_uk: nil,
               language: nil,
               "ctx-route-spec": "HomePage"
             },
             httpMethod: nil,
             path: "/_web_core/12345",
             pathParameters: %{
               "id" => "12345"
             },
             queryStringParameters: %{"q" => "something"}
           } == Request.build(envelope)
  end

  test "when session is valid", %{valid_session: envelope} do
    assert %{
             body: nil,
             headers: %{
               "accept-encoding": "gzip",
               country: nil,
               host: "bbc.co.uk",
               is_uk: nil,
               language: nil,
               authorization: "Bearer a-valid-session-token",
               "x-authentication-provider": "idv5",
               "pers-env": "int",
               "ctx-pii-age-bracket": "o18",
               "ctx-pii-allow-personalisation": "true",
               "ctx-route-spec": "HomePage"
             },
             httpMethod: nil,
             path: "/_web_core/12345",
             pathParameters: %{
               "id" => "12345"
             },
             queryStringParameters: %{"q" => "something"}
           } == Request.build(envelope)
  end

  test "when session is valid but user attributes are missing", %{valid_session_without_user_attributes: envelope} do
    assert %{
             body: nil,
             headers: %{
               "accept-encoding": "gzip",
               country: nil,
               host: "bbc.co.uk",
               is_uk: nil,
               language: nil,
               authorization: "Bearer a-valid-session-token",
               "x-authentication-provider": "idv5",
               "pers-env": "int",
               "ctx-route-spec": "HomePage"
             },
             httpMethod: nil,
             path: "/_web_core/12345",
             pathParameters: %{
               "id" => "12345"
             },
             queryStringParameters: %{"q" => "something"}
           } == Request.build(envelope)
  end

  test "when session is valid but user attributes are partially missing", %{
    valid_session_with_partial_user_attributes: envelope
  } do
    assert %{
             body: nil,
             headers: %{
               "accept-encoding": "gzip",
               country: nil,
               host: "bbc.co.uk",
               is_uk: nil,
               language: nil,
               authorization: "Bearer a-valid-session-token",
               "x-authentication-provider": "idv5",
               "pers-env": "int",
               "ctx-route-spec": "HomePage"
             },
             httpMethod: nil,
             path: "/_web_core/12345",
             pathParameters: %{
               "id" => "12345"
             },
             queryStringParameters: %{"q" => "something"}
           } == Request.build(envelope)
  end

  test "concatenates private.features into the feature header" do
    envelope_with_features = %Envelope{
      private: %Envelope.Private{
        features: %{chameleon: "off"}
      }
    }

    %{headers: %{"ctx-features": "chameleon=off"}} = Request.build(envelope_with_features)
  end

  test "adds election dials when set" do
    envelope_with_election_headers = %Envelope{
      request: %Envelope.Request{
        raw_headers: %{"election-banner-council-story" => "on", "election-banner-ni-story" => "off"}
      }
    }

    assert %{headers: %{"election-banner-council-story" => "on", "election-banner-ni-story" => "off"}} =
             Request.build(envelope_with_election_headers)
  end

  test "adds the Obit Mode header when set" do
    envelope_with_obit_mode_header = %Envelope{
      request: %Envelope.Request{
        raw_headers: %{"obit-mode" => "on"}
      }
    }

    assert %{headers: %{"obm" => "on"}} = Request.build(envelope_with_obit_mode_header)
  end
end
