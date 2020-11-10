defmodule Belfrage.Services.StubbedSessionTest do
  use ExUnit.Case

  alias Belfrage.Struct
  alias Belfrage.Services.StubbedSession

  test "valid session, authenticated and session token is provided" do
    struct = %Struct{
      private: %Struct.Private{
        valid_session: true,
        authenticated: true,
        session_token: "34fFErerG5464GereRGE3"
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
        valid_session: false,
        authenticated: true,
        session_token: "34fFErerG5464GereRGE3"
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
        valid_session: true,
        authenticated: false,
        session_token: "34fFErerG5464GereRGE3"
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
        valid_session: true,
        authenticated: true,
        session_token: nil
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
