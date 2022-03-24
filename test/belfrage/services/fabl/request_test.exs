defmodule Belfrage.Services.Fabl.RequestTest do
  use ExUnit.Case
  alias Belfrage.Services.Fabl.Request
  alias Belfrage.Clients
  alias Belfrage.Struct

  setup do
    valid_session = %Struct.UserSession{
      authentication_env: "int",
      session_token: "a-valid-session-token",
      authenticated: true,
      valid_session: true,
      user_attributes: %{age_bracket: "o18", allow_personalisation: true}
    }

    valid_session_without_user_attributes = %Struct.UserSession{
      authentication_env: "int",
      session_token: "a-valid-session-token",
      authenticated: true,
      valid_session: true,
      user_attributes: %{}
    }

    valid_session_with_partial_user_attributes = %Struct.UserSession{
      authentication_env: "int",
      session_token: "a-valid-session-token",
      authenticated: true,
      valid_session: true,
      user_attributes: %{allow_personalisation: true}
    }

    invalid_session = %Struct.UserSession{
      authentication_env: "int",
      session_token: "an-invalid-session-token",
      authenticated: true,
      valid_session: false,
      user_attributes: %{}
    }

    unauthenticated_session = %Struct.UserSession{
      authentication_env: "int",
      session_token: nil,
      authenticated: false,
      valid_session: false,
      user_attributes: %{}
    }

    struct = %Struct{
      request: %Struct.Request{
        method: "GET",
        path: "/fd/example-module",
        request_id: "arequestid",
        req_svc_chain: "Belfrage",
        path_params: %{
          "name" => "foobar"
        },
        query_params: %{
          "q" => "something"
        }
      },
      private: %Struct.Private{
        origin: "https://fabl.test.api.bbci.co.uk"
      }
    }

    %{
      valid_session: Struct.add(struct, :user_session, valid_session),
      valid_session_without_user_attributes: Struct.add(struct, :user_session, valid_session_without_user_attributes),
      valid_session_with_partial_user_attributes:
        Struct.add(struct, :user_session, valid_session_with_partial_user_attributes),
      invalid_session: Struct.add(struct, :user_session, invalid_session),
      unauthenticated_session: Struct.add(struct, :user_session, unauthenticated_session)
    }
  end

  describe "personalisation related requests" do
    test "builds a non-personalised request", %{unauthenticated_session: struct} do
      assert %Clients.HTTP.Request{
               headers: %{"accept-encoding" => "gzip", "req-svc-chain" => "Belfrage", "user-agent" => "Belfrage"},
               method: :get,
               payload: "",
               request_id: "arequestid",
               timeout: 6000,
               url: "https://fabl.test.api.bbci.co.uk/module/foobar?q=something"
             } == Request.build(struct)
    end

    test "builds a personalised request with user attribute headers", %{valid_session: struct} do
      assert %Clients.HTTP.Request{
               headers: %{
                 "accept-encoding" => "gzip",
                 "req-svc-chain" => "Belfrage",
                 "user-agent" => "Belfrage",
                 :authorization => "Bearer a-valid-session-token",
                 :"ctx-pii-age-bracket" => "o18",
                 :"ctx-pii-allow-personalisation" => "true",
                 :"pers-env" => "int",
                 :"x-authentication-provider" => "idv5"
               },
               method: :get,
               payload: "",
               request_id: "arequestid",
               timeout: 6000,
               url: "https://fabl.test.api.bbci.co.uk/module/foobar?q=something"
             } == Request.build(struct)
    end

    # Should this set allow personalisation and not set the age bracket?
    test "builds a personalised request with partial user attribute headers", %{
      valid_session_with_partial_user_attributes: struct
    } do
      assert %Clients.HTTP.Request{
               headers: %{
                 "accept-encoding" => "gzip",
                 "req-svc-chain" => "Belfrage",
                 "user-agent" => "Belfrage",
                 :authorization => "Bearer a-valid-session-token",
                 :"pers-env" => "int",
                 :"x-authentication-provider" => "idv5"
               },
               method: :get,
               payload: "",
               request_id: "arequestid",
               timeout: 6000,
               url: "https://fabl.test.api.bbci.co.uk/module/foobar?q=something"
             } == Request.build(struct)
    end

    test "builds a personalised request without user attribute headers", %{
      valid_session_without_user_attributes: struct
    } do
      assert %Clients.HTTP.Request{
               headers: %{
                 "accept-encoding" => "gzip",
                 "req-svc-chain" => "Belfrage",
                 "user-agent" => "Belfrage",
                 :authorization => "Bearer a-valid-session-token",
                 :"pers-env" => "int",
                 :"x-authentication-provider" => "idv5"
               },
               method: :get,
               payload: "",
               request_id: "arequestid",
               timeout: 6000,
               url: "https://fabl.test.api.bbci.co.uk/module/foobar?q=something"
             } == Request.build(struct)
    end

    test "builds a non personalised request", %{invalid_session: struct} do
      assert %Clients.HTTP.Request{
               headers: %{
                 "accept-encoding" => "gzip",
                 "req-svc-chain" => "Belfrage",
                 "user-agent" => "Belfrage"
               },
               method: :get,
               payload: "",
               request_id: "arequestid",
               timeout: 6000,
               url: "https://fabl.test.api.bbci.co.uk/module/foobar?q=something"
             } == Request.build(struct)
    end

    test "builds a non personalised request from an invalid session", %{invalid_session: struct} do
      assert %Clients.HTTP.Request{
               headers: %{
                 "accept-encoding" => "gzip",
                 "req-svc-chain" => "Belfrage",
                 "user-agent" => "Belfrage"
               },
               method: :get,
               payload: "",
               request_id: "arequestid",
               timeout: 6000,
               url: "https://fabl.test.api.bbci.co.uk/module/foobar?q=something"
             } == Request.build(struct)
    end
  end

  test "builds a non personalised request from an invalid session", %{invalid_session: struct} do
    assert %Clients.HTTP.Request{
             headers: %{
               "accept-encoding" => "gzip",
               "req-svc-chain" => "Belfrage",
               "user-agent" => "Belfrage"
             },
             method: :get,
             payload: "",
             request_id: "arequestid",
             timeout: 6000,
             url: "https://fabl.test.api.bbci.co.uk/module/foobar?q=something"
           } == Request.build(struct)
  end
end
