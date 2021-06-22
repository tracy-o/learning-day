defmodule Belfrage.Services.StubbedSessionTest do
  use ExUnit.Case

  alias Belfrage.Struct
  alias Belfrage.Services.StubbedSession

  test "valid session, authenticated and session token is provided" do
    struct = %Struct{
      private: %Struct.Private{
        session_state: %{
          authentication_environment: "int",
          session_token: "34fFErerG5464GereRGE3",
          valid_session: true,
          authenticated: true,
          user_attributes: %{}
        }
      }
    }

    assert %Struct{
             response: %Struct.Response{
               body: body,
               headers: %{
                 "cache-control" => "private",
                 "content-encoding" => "gzip",
                 "content-type" => "application/json"
               }
             }
           } = StubbedSession.dispatch(struct)

    assert %{"authenticated" => true, "session_token" => "Provided", "valid_session" => true} ==
             Jason.decode!(:zlib.gunzip(body))
  end

  test "invalid session, authenticated and session token is provided" do
    struct = %Struct{
      private: %Struct.Private{
        session_state: %{
          authentication_environment: "int",
          session_token: "34fFErerG5464GereRGE3",
          valid_session: false,
          authenticated: true,
          user_attributes: %{}
        }
      }
    }

    assert %Struct{
             response: %Struct.Response{
               body: body,
               headers: %{
                 "cache-control" => "private",
                 "content-encoding" => "gzip",
                 "content-type" => "application/json"
               }
             }
           } = StubbedSession.dispatch(struct)

    assert %{"authenticated" => true, "session_token" => "Provided", "valid_session" => false} ==
             Jason.decode!(:zlib.gunzip(body))
  end

  test "valid session, not authenticated and session token is provided" do
    struct = %Struct{
      private: %Struct.Private{
        session_state: %{
          authentication_environment: "int",
          session_token: "34fFErerG5464GereRGE3",
          valid_session: true,
          authenticated: false,
          user_attributes: %{}
        }
      }
    }

    assert %Struct{
             response: %Struct.Response{
               body: body,
               headers: %{
                 "cache-control" => "private",
                 "content-encoding" => "gzip",
                 "content-type" => "application/json"
               }
             }
           } = StubbedSession.dispatch(struct)

    assert %{"authenticated" => false, "session_token" => "Provided", "valid_session" => true} ==
             Jason.decode!(:zlib.gunzip(body))
  end

  test "valid session, authenticated and session token is not provided" do
    struct = %Struct{
      private: %Struct.Private{
        session_state: %{
          authentication_environment: "int",
          session_token: nil,
          valid_session: true,
          authenticated: true,
          user_attributes: %{}
        }
      }
    }

    assert %Struct{
             response: %Struct.Response{
               body: body,
               headers: %{
                 "cache-control" => "private",
                 "content-encoding" => "gzip",
                 "content-type" => "application/json"
               }
             }
           } = StubbedSession.dispatch(struct)

    assert %{"authenticated" => true, "session_token" => nil, "valid_session" => true} ==
             Jason.decode!(:zlib.gunzip(body))
  end
end
