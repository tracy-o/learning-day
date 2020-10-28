defmodule Belfrage.Transformers.UserSessionTest do
  use ExUnit.Case, async: true

  alias Belfrage.Transformers.UserSession
  alias Belfrage.Struct

  @token "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IlNPTUVfRUNfS0VZX0lEIn0.eyJzdWIiOiIzNGZlcnIzLWI0NmItNDk4Ni04ZTNjLTVhZjg5ZGZiZTAzZCIsImN0cyI6Ik9BVVRIMl9TVEFURUxFU1NfR1JBTlQiLCJhdXRoX2xldmVsIjowLCJhdWRpdFRyYWNraW5nSWQiOiJncmc2NTk2NS03MjIzLTRiNjctYWY0Mi0zNmYxNDI0MzE3ODMtMjQ0NTA5MzU0IiwiaXNzIjoiaHR0cHM6Ly9hY2Nlc3MuaW50LmFwaS5iYmMuY29tL2JiY2lkdjUvb2F1dGgyIiwidG9rZW5OYW1lIjoiYWNjZXNzX3Rva2VuIiwidG9rZW5fdHlwZSI6IkJlYXJlciIsImF1dGhHcmFudElkIjoiNWdydGFFaWU0eF8xczNnODRyNEQwdXFLQ00iLCJhdWQiOiJBY2NvdW50IiwibmJmIjoxNTkwNjE0MTgzLCJncmFudF90eXBlIjoicmVmcmVzaF90b2tlbiIsInNjb3BlIjpbImV4cGxpY2l0IiwidWlkIiwiaW1wbGljaXQiLCJwaWkiLCJjb3JlIiwib3BlbmlkIl0sImF1dGhfdGltZSI6MTU5MDUwMjc2MCwicmVhbG0iOiIvIiwiZXhwIjoxOTAxNTIxMzgzLCJpYXQiOjE1OTA2MTQxODMsImV4cGlyZXNfaW4iOjMxMDkwNzIwMCwianRpIjoiTjZGaE1WcGdVUnlTaFl1ekhnTHN4VzdsNWRJIn0.WzhZPWnuPq8up5-GEhg9IYetYu0S_PPeZkEXld229KnnJY0iC1ZdVSnji3uOLMIPG9mSgBuBAQNnu3MjP6DFFQ"

  test "cookie for 'ckns_id' only will be authenticated" do
    struct = %Struct{
      request: %Struct.Request{raw_headers: %{"cookie" => "ckns_id=1234"}}
    }

    assert {
             :ok,
             %Belfrage.Struct{
               private: %Belfrage.Struct.Private{
                 authenticated: true
               }
             }
           } = UserSession.call([], struct)
  end

  test "cookie for 'ckns_id' only will return nil session token" do
    struct = %Struct{
      request: %Struct.Request{raw_headers: %{"cookie" => "ckns_id=1234"}}
    }

    assert {
             :ok,
             %Belfrage.Struct{
               private: %Belfrage.Struct.Private{
                 session_token: nil
               }
             }
           } = UserSession.call([], struct)
  end

  test "cookie for 'ckns_id' and other keys will be authenticated" do
    struct = %Struct{
      request: %Struct.Request{raw_headers: %{"cookie" => "ckns_abc=def;ckns_id=1234;foo=bar"}}
    }

    assert {
             :ok,
             %Belfrage.Struct{
               private: %Belfrage.Struct.Private{
                 authenticated: true
               }
             }
           } = UserSession.call([], struct)
  end

  test "cookie for 'ckns_id' and `ckns_atkn` keys will be authenticated and store session token" do
    struct = %Struct{
      request: %Struct.Request{raw_headers: %{"cookie" => "ckns_abc=def;ckns_atkn=#{@token};ckns_id=1234;foo=bar"}}
    }

    assert {
             :ok,
             %Belfrage.Struct{
               private: %Belfrage.Struct.Private{
                 authenticated: true,
                 session_token: @token
               }
             }
           } = UserSession.call([], struct)
  end

  test "cookie for 'ckns_atkn' only and 'ckns_id' not set will not be authenticated and return nil session token" do
    struct = %Struct{
      request: %Struct.Request{raw_headers: %{"cookie" => "ckns_atkn=1234"}}
    }

    assert {
             :ok,
             %Belfrage.Struct{
               private: %Belfrage.Struct.Private{
                 authenticated: false,
                 session_token: nil
               }
             }
           } = UserSession.call([], struct)
  end

  test "cookie without 'ckns_id' will not be authenticated" do
    struct = %Struct{
      request: %Struct.Request{raw_headers: %{"cookie" => "ckns_abc=def"}}
    }

    assert {
             :ok,
             %Belfrage.Struct{
               private: %Belfrage.Struct.Private{
                 authenticated: false
               }
             }
           } = UserSession.call([], struct)
  end

  test "cookie without 'ckns_atkn' will return nil session token" do
    struct = %Struct{
      request: %Struct.Request{raw_headers: %{"cookie" => "ckns_abc=def"}}
    }

    assert {
             :ok,
             %Belfrage.Struct{
               private: %Belfrage.Struct.Private{
                 session_token: nil
               }
             }
           } = UserSession.call([], struct)
  end

  test "empty cookie will not be authenticated" do
    struct = %Struct{
      request: %Struct.Request{raw_headers: %{"cookie" => ""}}
    }

    assert {
             :ok,
             %Belfrage.Struct{
               private: %Belfrage.Struct.Private{
                 authenticated: false
               }
             }
           } = UserSession.call([], struct)
  end

  test "empty cookie will return nil session token" do
    struct = %Struct{
      request: %Struct.Request{raw_headers: %{"cookie" => ""}}
    }

    assert {
             :ok,
             %Belfrage.Struct{
               private: %Belfrage.Struct.Private{
                 session_token: nil
               }
             }
           } = UserSession.call([], struct)
  end

  test "no cookie will not be authenticated" do
    struct = %Struct{
      request: %Struct.Request{raw_headers: %{}}
    }

    assert {
             :ok,
             %Belfrage.Struct{
               private: %Belfrage.Struct.Private{
                 authenticated: false
               }
             }
           } = UserSession.call([], struct)
  end

  test "no cookie will return nil session token" do
    struct = %Struct{
      request: %Struct.Request{raw_headers: %{}}
    }

    assert {
             :ok,
             %Belfrage.Struct{
               private: %Belfrage.Struct.Private{
                 session_token: nil
               }
             }
           } = UserSession.call([], struct)
  end

  test "cookie for 'ckns_id' and `ckns_atkn` keys will be authenticated and set valid session" do
    struct = %Struct{
      request: %Struct.Request{raw_headers: %{"cookie" => "ckns_abc=def;ckns_atkn=#{@token};ckns_id=1234;foo=bar"}}
    }

    assert {
             :ok,
             %Belfrage.Struct{
               private: %Belfrage.Struct.Private{
                 authenticated: true,
                 session_token: @token,
                 valid_session: true
               }
             }
           } = UserSession.call([], struct)
  end
end
