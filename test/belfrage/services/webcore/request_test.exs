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
      },
      private: %Struct.Private{
        route_state_id: "HomePage"
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
           } == Request.build(struct)
  end

  test "when session is invalid", %{invalid_session: struct} do
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
               "pers-env": "int",
               "ctx-route-spec": "HomePage"
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
               "pers-env": "int",
               "ctx-route-spec": "HomePage"
             },
             httpMethod: nil,
             path: "/_web_core/12345",
             pathParameters: %{
               "id" => "12345"
             },
             queryStringParameters: %{"q" => "something"}
           } == Request.build(struct)
  end

  test "concatenates private.features into the feature header" do
    struct_with_features = %Struct{
      private: %Struct.Private{
        features: %{datalab_machine_recommendations: "enabled", chameleon: "off"}
      }
    }

    %{headers: %{"ctx-features": "chameleon=off,datalab_machine_recommendations=enabled"}} =
      Request.build(struct_with_features)
  end

  test "does not adds mvt playground header on live" do
    struct_with_environment = %Struct{
      private: %Struct.Private{
        production_environment: "live"
      }
    }
    refute Request.build(struct_with_environment)
    |> Map.get(:headers)
    |> Map.has_key?("mvt-box_colour_change")
  end

  test "adds mvt playground header when not on live" do
    struct_with_environment = %Struct{
      private: %Struct.Private{
        production_environment: "test"
      }
    }

    assert %{headers: %{"mvt-box_colour_change": "red"}} =
      Request.build(struct_with_environment)
  end
end
