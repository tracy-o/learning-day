defmodule Belfrage.Services.Webcore.RequestTest do
  use ExUnit.Case
  alias Belfrage.Services.Webcore.Request
  alias Belfrage.Struct

  setup do
    private_valid_session = %Struct.UserSession{
      authentication_env: "int",
      session_token: "a-valid-session-token",
      authenticated: true,
      valid_session: true,
      user_attributes: %{age_bracket: "o18", allow_personalisation: true}
    }

    private_valid_session_without_user_attributes = %Struct.UserSession{
      authentication_env: "int",
      session_token: "a-valid-session-token",
      authenticated: true,
      valid_session: true,
      user_attributes: %{}
    }

    private_valid_session_with_partial_user_attributes = %Struct.UserSession{
      authentication_env: "int",
      session_token: "a-valid-session-token",
      authenticated: true,
      valid_session: true,
      user_attributes: %{allow_personalisation: true}
    }

    private_invalid_session = %Struct.UserSession{
      authentication_env: "int",
      session_token: "an-invalid-session-token",
      authenticated: true,
      valid_session: false,
      user_attributes: %{}
    }

    private_unauthenticated_session = %Struct.UserSession{
      authentication_env: "int",
      session_token: nil,
      authenticated: false,
      valid_session: false,
      user_attributes: %{}
    }

    request_struct = %Struct{
      request: %Struct.Request{
        scheme: :https,
        host: "bbc.co.uk",
        path: "/_web_core/12345",
        path_params: %{
          "id" => "12345"
        },
        query_params: %{
          "q" => "something"
        }
      }
    }

    %{
      valid_session: Struct.add(request_struct, :user_session, private_valid_session),
      valid_session_without_user_attributes:
        Struct.add(request_struct, :user_session, private_valid_session_without_user_attributes),
      valid_session_with_partial_user_attributes:
        Struct.add(request_struct, :user_session, private_valid_session_with_partial_user_attributes),
      invalid_session: Struct.add(request_struct, :user_session, private_invalid_session),
      unauthenticated_session: Struct.add(request_struct, :user_session, private_unauthenticated_session)
    }
  end

  test "builds a non-personalised request", %{unauthenticated_session: struct} do
    assert %{
             body: nil,
             headers: %{"accept-encoding": "gzip", country: nil, host: "bbc.co.uk", is_uk: nil, language: nil},
             httpMethod: nil,
             path: "/_web_core/12345",
             pathParameters: %{
               "id" => "12345"
             },
             queryStringParameters: %{"q" => "something"}
           } == Request.build(struct)
  end

  test "when session is invalid", %{invalid_session: struct} do
    assert %{
             body: nil,
             headers: %{"accept-encoding": "gzip", country: nil, host: "bbc.co.uk", is_uk: nil, language: nil},
             httpMethod: nil,
             path: "/_web_core/12345",
             pathParameters: %{
               "id" => "12345"
             },
             queryStringParameters: %{"q" => "something"}
           } == Request.build(struct)
  end

  test "when session is valid", %{valid_session: struct} do
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
               "ctx-age-bracket": "o18",
               "ctx-allow-personalisation": "true"
             },
             httpMethod: nil,
             path: "/_web_core/12345",
             pathParameters: %{
               "id" => "12345"
             },
             queryStringParameters: %{"q" => "something"}
           } == Request.build(struct)
  end

  test "when session is valid but user attributes are missing", %{valid_session_without_user_attributes: struct} do
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
               "pers-env": "int"
             },
             httpMethod: nil,
             path: "/_web_core/12345",
             pathParameters: %{
               "id" => "12345"
             },
             queryStringParameters: %{"q" => "something"}
           } == Request.build(struct)
  end

  test "when session is valid but user attributes are partially missing", %{
    valid_session_with_partial_user_attributes: struct
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
               "pers-env": "int"
             },
             httpMethod: nil,
             path: "/_web_core/12345",
             pathParameters: %{
               "id" => "12345"
             },
             queryStringParameters: %{"q" => "something"}
           } == Request.build(struct)
  end
end
