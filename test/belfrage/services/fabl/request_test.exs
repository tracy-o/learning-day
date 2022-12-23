defmodule Belfrage.Services.Fabl.RequestTest do
  use ExUnit.Case
  alias Belfrage.Services.Fabl.Request
  alias Belfrage.Clients
  alias Belfrage.Struct
  alias Belfrage.Xray
  use Belfrage.Test.XrayHelper

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
        origin: "https://fabl.test.api.bbci.co.uk",
        personalised_route: true
      }
    }

    struct_without_name_path_param = %Struct{
      request: %Struct.Request{
        method: "GET",
        path: "/fd/p/mytopics-page",
        request_id: "arequestid",
        req_svc_chain: "Belfrage",
        query_params: %{
          "q" => "something"
        }
      },
      private: %Struct.Private{
        origin: "https://fabl.test.api.bbci.co.uk",
        personalised_route: true
      }
    }

    %{
      valid_session: Struct.add(struct, :user_session, valid_session),
      valid_session_no_name_param: Struct.add(struct_without_name_path_param, :user_session, valid_session),
      valid_session_without_user_attributes: Struct.add(struct, :user_session, valid_session_without_user_attributes),
      valid_session_with_partial_user_attributes:
        Struct.add(struct, :user_session, valid_session_with_partial_user_attributes),
      invalid_session: Struct.add(struct, :user_session, invalid_session),
      unauthenticated_session: Struct.add(struct, :user_session, unauthenticated_session)
    }
  end

  describe "personalised route requests" do
    test "builds a non-personalised request", %{unauthenticated_session: struct} do
      assert %Clients.HTTP.Request{
               headers: %{"accept-encoding" => "gzip", "req-svc-chain" => "Belfrage", "user-agent" => "Belfrage"},
               method: :get,
               payload: "",
               request_id: "arequestid",
               timeout: 6000,
               url: "https://fabl.test.api.bbci.co.uk/personalised-module/foobar?q=something"
             } == Request.build(struct)
    end

    test "builds a personalised request with user attribute headers", %{valid_session: struct} do
      assert %Clients.HTTP.Request{
               headers: %{
                 "accept-encoding" => "gzip",
                 "req-svc-chain" => "Belfrage",
                 "user-agent" => "Belfrage",
                 "authorization" => "Bearer a-valid-session-token",
                 "ctx-pii-age-bracket" => "o18",
                 "ctx-pii-allow-personalisation" => "true",
                 "ctx-pers-env" => "int",
                 "x-authentication-provider" => "idv5"
               },
               method: :get,
               payload: "",
               request_id: "arequestid",
               timeout: 6000,
               url: "https://fabl.test.api.bbci.co.uk/personalised-module/foobar?q=something"
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
                 "authorization" => "Bearer a-valid-session-token",
                 "ctx-pers-env" => "int",
                 "x-authentication-provider" => "idv5"
               },
               method: :get,
               payload: "",
               request_id: "arequestid",
               timeout: 6000,
               url: "https://fabl.test.api.bbci.co.uk/personalised-module/foobar?q=something"
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
                 "authorization" => "Bearer a-valid-session-token",
                 "ctx-pers-env" => "int",
                 "x-authentication-provider" => "idv5"
               },
               method: :get,
               payload: "",
               request_id: "arequestid",
               timeout: 6000,
               url: "https://fabl.test.api.bbci.co.uk/personalised-module/foobar?q=something"
             } == Request.build(struct)
    end

    test ~s(path prefixed with "/fd/preview" is updated to "/preview/personalised-module/" when route is personalised) do
      assert %Clients.HTTP.Request{
               url: "https://fabl.test.api.bbci.co.uk/preview/personalised-module/foobar?q=something"
             } =
               Request.build(%Struct{
                 request: %Struct.Request{
                   method: "GET",
                   path: "/fd/preview/",
                   request_id: "arequestid",
                   path_params: %{
                     "name" => "foobar"
                   },
                   query_params: %{
                     "q" => "something"
                   }
                 },
                 private: %Struct.Private{
                   origin: "https://fabl.test.api.bbci.co.uk",
                   personalised_route: true
                 }
               })
    end

    test ~s(path not prefixed with "/fd/preview/" is updated to "/personalised-module/" when route is personalised) do
      assert %Clients.HTTP.Request{url: "https://fabl.test.api.bbci.co.uk/personalised-module/foobar?q=something"} =
               Request.build(%Struct{
                 request: %Struct.Request{
                   method: "GET",
                   path: "/fd/example-module",
                   request_id: "arequestid",
                   path_params: %{
                     "name" => "foobar"
                   },
                   query_params: %{
                     "q" => "something"
                   }
                 },
                 private: %Struct.Private{
                   origin: "https://fabl.test.api.bbci.co.uk",
                   personalised_route: true
                 }
               })
    end

    test ~s(path prefixed with "/fd/preview" is updated to "/preview/module/" when route is not personalised) do
      assert %Clients.HTTP.Request{url: "https://fabl.test.api.bbci.co.uk/preview/module/foobar?q=something"} =
               Request.build(%Struct{
                 request: %Struct.Request{
                   method: "GET",
                   path: "/fd/preview/",
                   request_id: "arequestid",
                   path_params: %{
                     "name" => "foobar"
                   },
                   query_params: %{
                     "q" => "something"
                   }
                 },
                 private: %Struct.Private{
                   origin: "https://fabl.test.api.bbci.co.uk",
                   personalised_route: false
                 }
               })
    end

    test ~s(path not prefixed with "/fd/preview" is updated to "/module/" when route is not personalised) do
      assert %Clients.HTTP.Request{url: "https://fabl.test.api.bbci.co.uk/module/foobar?q=something"} =
               Request.build(%Struct{
                 request: %Struct.Request{
                   method: "GET",
                   path: "/something",
                   request_id: "arequestid",
                   path_params: %{
                     "name" => "foobar"
                   },
                   query_params: %{
                     "q" => "something"
                   }
                 },
                 private: %Struct.Private{
                   origin: "https://fabl.test.api.bbci.co.uk",
                   personalised_route: false
                 }
               })
    end

    test ~s(mytopics pages are prefixed with "/personalised-module/" when route is personalised) do
      Enum.each(~w(mytopics-page mytopics-follows), fn module ->
        url = "https://fabl.test.api.bbci.co.uk/personalised-module/#{module}?q=something"

        assert %Clients.HTTP.Request{url: ^url} =
                 Request.build(%Struct{
                   request: %Struct.Request{
                     method: "GET",
                     path: "/fd/p/#{module}",
                     request_id: "arequestid",
                     path_params: %{},
                     query_params: %{
                       "q" => "something"
                     }
                   },
                   private: %Struct.Private{
                     origin: "https://fabl.test.api.bbci.co.uk",
                     personalised_route: true
                   }
                 })
      end)
    end

    test ~s(sport pages are prefixed with "/module/" when route is not personalised) do
      Enum.each(
        ~w(sport-app-allsport sport-app-followables sport-app-images sport-app-menu sport-app-notification-data sport-app-page topic-mapping),
        fn module ->
          url = "https://fabl.test.api.bbci.co.uk/module/#{module}?q=something"

          assert %Clients.HTTP.Request{url: ^url} =
                   Request.build(%Struct{
                     request: %Struct.Request{
                       method: "GET",
                       path: "/fd/#{module}",
                       request_id: "arequestid",
                       path_params: %{},
                       query_params: %{
                         "q" => "something"
                       }
                     },
                     private: %Struct.Private{
                       origin: "https://fabl.test.api.bbci.co.uk",
                       personalised_route: false
                     }
                   })
        end
      )
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
               url: "https://fabl.test.api.bbci.co.uk/personalised-module/foobar?q=something"
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
               url: "https://fabl.test.api.bbci.co.uk/personalised-module/foobar?q=something"
             } == Request.build(struct)
    end
  end

  describe "non-personalised route requests" do
    test "builds a non-personalised request", %{unauthenticated_session: struct} do
      struct = Struct.add(struct, :private, %{personalised_route: false})

      assert %Clients.HTTP.Request{
               headers: %{"accept-encoding" => "gzip", "req-svc-chain" => "Belfrage", "user-agent" => "Belfrage"},
               method: :get,
               payload: "",
               request_id: "arequestid",
               timeout: 6000,
               url: "https://fabl.test.api.bbci.co.uk/module/foobar?q=something"
             } == Request.build(struct)
    end
  end

  describe "requests without name param" do
    test "personalised", %{valid_session_no_name_param: struct_without_name_path_param} do
      assert %Clients.HTTP.Request{
               headers: %{
                 "accept-encoding" => "gzip",
                 "req-svc-chain" => "Belfrage",
                 "user-agent" => "Belfrage",
                 "authorization" => "Bearer a-valid-session-token",
                 "ctx-pii-age-bracket" => "o18",
                 "ctx-pii-allow-personalisation" => "true",
                 "ctx-pers-env" => "int",
                 "x-authentication-provider" => "idv5"
               },
               method: :get,
               payload: "",
               request_id: "arequestid",
               timeout: 6000,
               url: "https://fabl.test.api.bbci.co.uk/personalised-module/mytopics-page?q=something"
             } == Request.build(struct_without_name_path_param)
    end
  end

  describe "X-Ray trace id" do
    test "builds a request with a x-amzn-trace-id when segment present", %{invalid_session: struct} do
      x_ray_segment = build_segment(sampled: true)
      struct_with_segment = put_in(struct.request.xray_segment, x_ray_segment)

      assert %Clients.HTTP.Request{
               headers: %{
                 "accept-encoding" => "gzip",
                 "req-svc-chain" => "Belfrage",
                 "user-agent" => "Belfrage",
                 "x-amzn-trace-id" => Xray.build_trace_id_header(x_ray_segment)
               },
               method: :get,
               payload: "",
               request_id: "arequestid",
               timeout: 6000,
               url: "https://fabl.test.api.bbci.co.uk/personalised-module/foobar?q=something"
             } == Request.build(struct_with_segment)
    end
  end
end
