defmodule Belfrage.Transformers.UserSessionTest do
  use ExUnit.Case, async: true

  alias Belfrage.Transformers.UserSession
  alias Belfrage.Struct

  @token Fixtures.AuthToken.valid_access_token()

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

  describe "unhappy paths" do
    setup do
      %{
        expired_access_token: Fixtures.AuthToken.expired_access_token(),
        invalid_access_token: Fixtures.AuthToken.invalid_access_token(),
        invalid_payload_access_token: Fixtures.AuthToken.invalid_payload_access_token(),
        invalid_scope_access_token: Fixtures.AuthToken.invalid_scope_access_token()
      }
    end

    # This behviour to be confirmed with account team.
    test "accepts an invalid scope access token as valid", %{invalid_scope_access_token: access_token} do
      struct = Struct.add(%Struct{}, :request, %{raw_headers: %{"cookie" => "ckns_atkn=#{access_token};ckns_id=1234;"}})

      assert {
               :ok,
               %Belfrage.Struct{
                 private: %Belfrage.Struct.Private{
                   authenticated: true,
                   session_token: ^access_token,
                   valid_session: true
                 }
               }
             } = UserSession.call([], struct)
    end

    test "invalid payload access token", %{invalid_payload_access_token: access_token} do
      struct = Struct.add(%Struct{}, :request, %{raw_headers: %{"cookie" => "ckns_atkn=#{access_token};ckns_id=1234;"}})

      assert {
               :ok,
               %Belfrage.Struct{
                 private: %Belfrage.Struct.Private{
                   authenticated: true,
                   session_token: ^access_token,
                   valid_session: false
                 }
               }
             } = UserSession.call([], struct)
    end

    test "invalid access token", %{invalid_access_token: access_token} do
      struct = Struct.add(%Struct{}, :request, %{raw_headers: %{"cookie" => "ckns_atkn=#{access_token};ckns_id=1234;"}})

      assert {
               :ok,
               %Belfrage.Struct{
                 private: %Belfrage.Struct.Private{
                   authenticated: true,
                   session_token: ^access_token,
                   valid_session: false
                 }
               }
             } = UserSession.call([], struct)
    end

    test "expired access token", %{expired_access_token: access_token} do
      struct = Struct.add(%Struct{}, :request, %{raw_headers: %{"cookie" => "ckns_atkn=#{access_token};ckns_id=1234;"}})

      assert {
               :ok,
               %Belfrage.Struct{
                 private: %Belfrage.Struct.Private{
                   authenticated: true,
                   session_token: ^access_token,
                   valid_session: false
                 }
               }
             } = UserSession.call([], struct)
    end
  end
end
