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

  test "does not add mvt headers when none set" do
    struct_with_environment = %Struct{}

    refute Request.build(struct_with_environment)
           |> Map.get(:headers)
           |> Map.keys()
           |> Enum.map(&to_string/1)
           |> Enum.any?(fn header -> String.starts_with?(header, "mvt-") end)
  end

  test "adds mvt headers when set" do
    struct_with_mvt = %Struct{
      private: %Struct.Private{
        mvt: %{"mvt-button_colour" => {1, "experiment;red"}, "mvt-sidebar" => {5, "feature;false"}}
      }
    }

    assert %{headers: %{"mvt-button_colour" => "experiment;red", "mvt-sidebar" => "feature;false"}} =
             Request.build(struct_with_mvt)
  end

  test "adds election dials when set" do
    struct_with_election_headers = %Struct{
      request: %Struct.Request{
        raw_headers: %{"election-banner-council-story" => "on", "election-banner-ni-story" => "off"}
      }
    }

    assert %{headers: %{"election-banner-council-story" => "on", "election-banner-ni-story" => "off"}} =
             Request.build(struct_with_election_headers)
  end

  test "adds the Obit Mode header when set" do
    struct_with_obit_mode_header = %Struct{
      request: %Struct.Request{
        raw_headers: %{"obit-mode" => "on"}
      }
    }

    assert %{headers: %{"obm" => "on"}} = Request.build(struct_with_obit_mode_header)
  end
end
