defmodule Belfrage.Services.StubbedSessionTest do
  use ExUnit.Case

  alias Belfrage.Envelope
  alias Belfrage.Services.StubbedSession

  test "valid session, authenticated and session token is provided" do
    envelope = %Envelope{
      user_session: %Envelope.UserSession{
        authentication_env: "int",
        session_token: "34fFErerG5464GereRGE3",
        valid_session: true,
        authenticated: true,
        user_attributes: %{}
      }
    }

    assert %Envelope{
             response: %Envelope.Response{
               body: body,
               headers: %{
                 "cache-control" => "private",
                 "content-encoding" => "gzip",
                 "content-type" => "application/json"
               }
             }
           } = StubbedSession.dispatch(envelope)

    assert %{"authenticated" => true, "session_token" => "Provided", "valid_session" => true} ==
             Jason.decode!(:zlib.gunzip(body))
  end

  test "invalid session, authenticated and session token is provided" do
    envelope = %Envelope{
      user_session: %Envelope.UserSession{
        authentication_env: "int",
        session_token: "34fFErerG5464GereRGE3",
        valid_session: false,
        authenticated: true,
        user_attributes: %{}
      }
    }

    assert %Envelope{
             response: %Envelope.Response{
               body: body,
               headers: %{
                 "cache-control" => "private",
                 "content-encoding" => "gzip",
                 "content-type" => "application/json"
               }
             }
           } = StubbedSession.dispatch(envelope)

    assert %{"authenticated" => true, "session_token" => "Provided", "valid_session" => false} ==
             Jason.decode!(:zlib.gunzip(body))
  end

  test "valid session, not authenticated and session token is provided" do
    envelope = %Envelope{
      user_session: %Envelope.UserSession{
        authentication_env: "int",
        session_token: "34fFErerG5464GereRGE3",
        valid_session: true,
        authenticated: false,
        user_attributes: %{}
      }
    }

    assert %Envelope{
             response: %Envelope.Response{
               body: body,
               headers: %{
                 "cache-control" => "private",
                 "content-encoding" => "gzip",
                 "content-type" => "application/json"
               }
             }
           } = StubbedSession.dispatch(envelope)

    assert %{"authenticated" => false, "session_token" => "Provided", "valid_session" => true} ==
             Jason.decode!(:zlib.gunzip(body))
  end

  test "valid session, authenticated and session token is not provided" do
    envelope = %Envelope{
      user_session: %Envelope.UserSession{
        authentication_env: "int",
        session_token: nil,
        valid_session: true,
        authenticated: true,
        user_attributes: %{}
      }
    }

    assert %Envelope{
             response: %Envelope.Response{
               body: body,
               headers: %{
                 "cache-control" => "private",
                 "content-encoding" => "gzip",
                 "content-type" => "application/json"
               }
             }
           } = StubbedSession.dispatch(envelope)

    assert %{"authenticated" => true, "session_token" => nil, "valid_session" => true} ==
             Jason.decode!(:zlib.gunzip(body))
  end
end
