defmodule Belfrage.Transformers.UserSessionTest do
  use ExUnit.Case, async: true
  import ExUnit.CaptureLog

  alias Belfrage.Transformers.UserSession
  alias Belfrage.Struct

  @token Fixtures.AuthToken.valid_access_token()

  setup do
    %{
      struct: %Struct{
        request: %Struct.Request{
          path: "/search",
          scheme: :http,
          host: "bbc.co.uk",
          query_params: %{"q" => "5tr!ctly c0m3 d@nc!nG"}
        }
      }
    }
  end

  test "cookie for 'ckns_id' only will be authenticated", %{struct: struct} do
    struct = Struct.add(struct, :request, %{raw_headers: %{"cookie" => "ckns_id=1234"}})

    assert {
             :redirect,
             %Belfrage.Struct{
               private: %Belfrage.Struct.Private{
                 authenticated: true,
                 valid_session: false
               }
             }
           } = UserSession.call([], struct)
  end

  test "cookie for 'ckns_id' only will be redirected", %{struct: struct} do
    struct = Struct.add(struct, :request, %{raw_headers: %{"cookie" => "ckns_id=1234"}})

    assert {
             :redirect,
             %Belfrage.Struct{
               response: %Belfrage.Struct.Response{
                 headers: %{
                   "location" =>
                     "https://session.test.bbc.co.uk/account?ptrt=http%3A%2F%2Fbbc.co.uk%2Fsearch%3Fq=5tr%21ctly+c0m3+d%40nc%21nG",
                   "x-bbc-no-scheme-rewrite" => "1",
                   "cache-control" => "public, stale-while-revalidate=10, max-age=60"
                 }
               }
             }
           } = UserSession.call([], struct)
  end

  test "cookie for 'ckns_id' only will return nil session token", %{struct: struct} do
    struct = Struct.add(struct, :request, %{raw_headers: %{"cookie" => "ckns_id=1234"}})

    assert {
             :redirect,
             %Belfrage.Struct{
               private: %Belfrage.Struct.Private{
                 session_token: nil
               }
             }
           } = UserSession.call([], struct)
  end

  test "cookie for 'ckns_id' and other keys will be authenticated", %{struct: struct} do
    struct = Struct.add(struct, :request, %{raw_headers: %{"cookie" => "ckns_abc=def;ckns_id=1234;foo=bar"}})

    assert {
             :redirect,
             %Belfrage.Struct{
               private: %Belfrage.Struct.Private{
                 authenticated: true
               }
             }
           } = UserSession.call([], struct)
  end

  test "cookie for 'ckns_id' and other keys will be redirected", %{struct: struct} do
    struct = Struct.add(struct, :request, %{raw_headers: %{"cookie" => "ckns_abc=def;ckns_id=1234;foo=bar"}})

    assert {
             :redirect,
             %Belfrage.Struct{
               response: %Belfrage.Struct.Response{
                 headers: %{
                   "location" =>
                     "https://session.test.bbc.co.uk/account?ptrt=http%3A%2F%2Fbbc.co.uk%2Fsearch%3Fq=5tr%21ctly+c0m3+d%40nc%21nG",
                   "x-bbc-no-scheme-rewrite" => "1",
                   "cache-control" => "public, stale-while-revalidate=10, max-age=60"
                 }
               }
             }
           } = UserSession.call([], struct)
  end

  test "cookie for 'ckns_atkn' only and 'ckns_id' not set will not be authenticated and return nil session token", %{
    struct: struct
  } do
    struct = Struct.add(struct, :request, %{raw_headers: %{"cookie" => "ckns_atkn=1234"}})

    assert {
             :redirect,
             %Belfrage.Struct{
               private: %Belfrage.Struct.Private{
                 authenticated: false,
                 session_token: nil
               }
             }
           } = UserSession.call([], struct)
  end

  test "cookie for 'ckns_atkn' only and 'ckns_id' not set will be redirected",
       %{
         struct: struct
       } do
    struct = Struct.add(struct, :request, %{raw_headers: %{"cookie" => "ckns_atkn=1234"}})

    assert {
             :redirect,
             %Belfrage.Struct{
               response: %Belfrage.Struct.Response{
                 headers: %{
                   "location" =>
                     "https://session.test.bbc.co.uk/account?ptrt=http%3A%2F%2Fbbc.co.uk%2Fsearch%3Fq=5tr%21ctly+c0m3+d%40nc%21nG",
                   "x-bbc-no-scheme-rewrite" => "1",
                   "cache-control" => "public, stale-while-revalidate=10, max-age=60"
                 }
               }
             }
           } = UserSession.call([], struct)
  end

  test "cookie without 'ckns_id' will not be authenticated", %{struct: struct} do
    struct = Struct.add(struct, :request, %{raw_headers: %{"cookie" => "ckns_abc=def"}})

    assert {
             :redirect,
             %Belfrage.Struct{
               private: %Belfrage.Struct.Private{
                 authenticated: false
               }
             }
           } = UserSession.call([], struct)
  end

  test "cookie without 'ckns_atkn' will be redirected", %{struct: struct} do
    struct = Struct.add(struct, :request, %{raw_headers: %{"cookie" => "ckns_abc=def"}})

    assert {
             :redirect,
             %Belfrage.Struct{
               response: %Belfrage.Struct.Response{
                 headers: %{
                   "location" =>
                     "https://session.test.bbc.co.uk/account?ptrt=http%3A%2F%2Fbbc.co.uk%2Fsearch%3Fq=5tr%21ctly+c0m3+d%40nc%21nG",
                   "x-bbc-no-scheme-rewrite" => "1",
                   "cache-control" => "public, stale-while-revalidate=10, max-age=60"
                 }
               }
             }
           } = UserSession.call([], struct)
  end

  test "cookie without 'ckns_atkn' will return nil session token", %{struct: struct} do
    struct = Struct.add(struct, :request, %{raw_headers: %{"cookie" => "ckns_abc=def"}})

    assert {
             :redirect,
             %Belfrage.Struct{
               private: %Belfrage.Struct.Private{
                 session_token: nil
               }
             }
           } = UserSession.call([], struct)
  end

  test "empty cookie will not be authenticated", %{struct: struct} do
    struct = Struct.add(struct, :request, %{raw_headers: %{"cookie" => ""}})

    assert {
             :redirect,
             %Belfrage.Struct{
               private: %Belfrage.Struct.Private{
                 authenticated: false
               }
             }
           } = UserSession.call([], struct)
  end

  test "empty cookie will be redirected", %{struct: struct} do
    struct = Struct.add(struct, :request, %{raw_headers: %{"cookie" => ""}})

    assert {
             :redirect,
             %Belfrage.Struct{
               response: %Belfrage.Struct.Response{
                 headers: %{
                   "location" =>
                     "https://session.test.bbc.co.uk/account?ptrt=http%3A%2F%2Fbbc.co.uk%2Fsearch%3Fq=5tr%21ctly+c0m3+d%40nc%21nG",
                   "x-bbc-no-scheme-rewrite" => "1",
                   "cache-control" => "public, stale-while-revalidate=10, max-age=60"
                 }
               }
             }
           } = UserSession.call([], struct)
  end

  test "empty cookie will return nil session token", %{struct: struct} do
    struct = Struct.add(struct, :request, %{raw_headers: %{"cookie" => "ckns_abc=def;ckns_id=1234;foo=bar"}})

    assert {
             :redirect,
             %Belfrage.Struct{
               private: %Belfrage.Struct.Private{
                 session_token: nil
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

  describe "unhappy access token paths (when public keys exist)" do
    setup do
      %{
        expired_access_token: Fixtures.AuthToken.expired_access_token(),
        invalid_access_token: Fixtures.AuthToken.invalid_access_token(),
        invalid_payload_access_token: Fixtures.AuthToken.invalid_payload_access_token(),
        invalid_scope_access_token: Fixtures.AuthToken.invalid_scope_access_token(),
        malformed_access_token: Fixtures.AuthToken.malformed_access_token(),
        invalid_access_token_header: Fixtures.AuthToken.invalid_access_token_header(),
        invalid_token_issuer: Fixtures.AuthToken.invalid_token_issuer(),
        invalid_token_aud: Fixtures.AuthToken.invalid_token_aud(),
        invalid_token_name: Fixtures.AuthToken.invalid_token_name()
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

<<<<<<< HEAD
=======
<<<<<<< HEAD
<<<<<<< HEAD
    test "invalid payload access token", %{struct: struct, invalid_payload_access_token: access_token} do
      struct = Struct.add(struct, :request, %{raw_headers: %{"cookie" => "ckns_atkn=#{access_token};ckns_id=1234;"}})

      assert {
               :redirect,
               %Belfrage.Struct{
                 private: %Belfrage.Struct.Private{
                   authenticated: true,
                   session_token: ^access_token,
                   valid_session: false
=======
>>>>>>> aeef47e2... formatting
  test "invalid access token", %{struct: struct, invalid_access_token: access_token} do
    struct = Struct.add(struct, :request, %{raw_headers: %{"cookie" => "ckns_atkn=#{access_token};ckns_id=1234;"}})
=======
    test "invalid payload access token", %{struct: struct, invalid_payload_access_token: access_token} do
      struct = Struct.add(struct, :request, %{raw_headers: %{"cookie" => "ckns_atkn=#{access_token};ckns_id=1234;"}})
>>>>>>> 9953de70... formatting

      assert {
               :redirect,
               %Belfrage.Struct{
                 private: %Belfrage.Struct.Private{
                   authenticated: true,
                   session_token: ^access_token,
                   valid_session: false
                 }
               }
             } = UserSession.call([], struct)
    end

    test "invalid payload access token will be redirected", %{
      struct: struct,
      invalid_payload_access_token: access_token
    } do
      struct = Struct.add(struct, :request, %{raw_headers: %{"cookie" => "ckns_atkn=#{access_token};ckns_id=1234;"}})

<<<<<<< HEAD
    assert {
             :redirect,
             %Belfrage.Struct{
               response: %Belfrage.Struct.Response{
                 headers: %{
                   "location" =>
                     "https://session.test.bbc.co.uk/account?ptrt=http%3A%2F%2Fbbc.co.uk%2Fsearch%3Fq=5tr%21ctly+c0m3+d%40nc%21nG",
                   "x-bbc-no-scheme-rewrite" => "1",
                   "cache-control" => "public, stale-while-revalidate=10, max-age=60"
<<<<<<< HEAD
=======
>>>>>>> c0fa8764... Added redirect for invalid or expired token
=======
      assert {
               :redirect,
               %Belfrage.Struct{
                 response: %Belfrage.Struct.Response{
                   headers: %{
                     "location" =>
                       "https://session.test.bbc.co.uk/account?ptrt=http%3A%2F%2Fbbc.co.uk%2Fsearch%3Fq=5tr%21ctly+c0m3+d%40nc%21nG",
                     "x-bbc-no-scheme-rewrite" => "1",
                     "cache-control" => "public, stale-while-revalidate=10, max-age=60"
                   }
>>>>>>> 9953de70... formatting
>>>>>>> aeef47e2... formatting
                 }
               }
             } = UserSession.call([], struct)
    end

<<<<<<< HEAD
=======
<<<<<<< HEAD
<<<<<<< HEAD
    test "invalid payload access token will be redirected", %{
      struct: struct,
      invalid_payload_access_token: access_token
    } do
      struct = Struct.add(struct, :request, %{raw_headers: %{"cookie" => "ckns_atkn=#{access_token};ckns_id=1234;"}})

      assert {
               :redirect,
               %Belfrage.Struct{
                 response: %Belfrage.Struct.Response{
                   headers: %{
                     "location" =>
                       "https://session.test.bbc.co.uk/account?ptrt=http%3A%2F%2Fbbc.co.uk%2Fsearch%3Fq=5tr%21ctly+c0m3+d%40nc%21nG",
                     "x-bbc-no-scheme-rewrite" => "1",
                     "cache-control" => "public, stale-while-revalidate=10, max-age=60"
                   }
                 }
               }
             } = UserSession.call([], struct)
    end

    test "invalid access token", %{struct: struct, invalid_access_token: access_token} do
      struct = Struct.add(struct, :request, %{raw_headers: %{"cookie" => "ckns_atkn=#{access_token};ckns_id=1234;"}})

      assert {
               :redirect,
               %Belfrage.Struct{
                 private: %Belfrage.Struct.Private{
                   authenticated: true,
                   session_token: ^access_token,
                   valid_session: false
=======
>>>>>>> aeef47e2... formatting
  test "expired access token", %{struct: struct, expired_access_token: access_token} do
    struct = Struct.add(struct, :request, %{raw_headers: %{"cookie" => "ckns_atkn=#{access_token};ckns_id=1234;"}})
=======
    test "invalid access token", %{struct: struct, invalid_access_token: access_token} do
      struct = Struct.add(struct, :request, %{raw_headers: %{"cookie" => "ckns_atkn=#{access_token};ckns_id=1234;"}})
>>>>>>> 9953de70... formatting

      assert {
               :redirect,
               %Belfrage.Struct{
                 private: %Belfrage.Struct.Private{
                   authenticated: true,
                   session_token: ^access_token,
                   valid_session: false
                 }
               }
             } = UserSession.call([], struct)
    end

    test "invalid access token will be redirected", %{struct: struct, invalid_access_token: access_token} do
      struct = Struct.add(struct, :request, %{raw_headers: %{"cookie" => "ckns_atkn=#{access_token};ckns_id=1234;"}})

<<<<<<< HEAD
    assert {
             :redirect,
             %Belfrage.Struct{
               response: %Belfrage.Struct.Response{
                 headers: %{
                   "location" =>
                     "https://session.test.bbc.co.uk/account?ptrt=http%3A%2F%2Fbbc.co.uk%2Fsearch%3Fq=5tr%21ctly+c0m3+d%40nc%21nG",
                   "x-bbc-no-scheme-rewrite" => "1",
                   "cache-control" => "public, stale-while-revalidate=10, max-age=60"
<<<<<<< HEAD
=======
>>>>>>> c0fa8764... Added redirect for invalid or expired token
=======
      assert {
               :redirect,
               %Belfrage.Struct{
                 response: %Belfrage.Struct.Response{
                   headers: %{
                     "location" =>
                       "https://session.test.bbc.co.uk/account?ptrt=http%3A%2F%2Fbbc.co.uk%2Fsearch%3Fq=5tr%21ctly+c0m3+d%40nc%21nG",
                     "x-bbc-no-scheme-rewrite" => "1",
                     "cache-control" => "public, stale-while-revalidate=10, max-age=60"
                   }
>>>>>>> 9953de70... formatting
>>>>>>> aeef47e2... formatting
                 }
               }
             } = UserSession.call([], struct)
    end

<<<<<<< HEAD
=======
<<<<<<< HEAD
<<<<<<< HEAD
    test "invalid access token will be redirected", %{struct: struct, invalid_access_token: access_token} do
      struct = Struct.add(struct, :request, %{raw_headers: %{"cookie" => "ckns_atkn=#{access_token};ckns_id=1234;"}})

      assert {
               :redirect,
               %Belfrage.Struct{
                 response: %Belfrage.Struct.Response{
                   headers: %{
                     "location" =>
                       "https://session.test.bbc.co.uk/account?ptrt=http%3A%2F%2Fbbc.co.uk%2Fsearch%3Fq=5tr%21ctly+c0m3+d%40nc%21nG",
                     "x-bbc-no-scheme-rewrite" => "1",
                     "cache-control" => "public, stale-while-revalidate=10, max-age=60"
                   }
                 }
               }
             } = UserSession.call([], struct)
    end

    test "expired access token", %{struct: struct, expired_access_token: access_token} do
      struct = Struct.add(struct, :request, %{raw_headers: %{"cookie" => "ckns_atkn=#{access_token};ckns_id=1234;"}})

      assert {
               :redirect,
               %Belfrage.Struct{
                 private: %Belfrage.Struct.Private{
                   authenticated: true,
                   session_token: ^access_token,
                   valid_session: false
=======
>>>>>>> aeef47e2... formatting
  test "a malformed access token", %{struct: struct, malformed_access_token: access_token} do
    struct = Struct.add(struct, :request, %{raw_headers: %{"cookie" => "ckns_atkn=#{access_token};ckns_id=1234;"}})
=======
    test "expired access token", %{struct: struct, expired_access_token: access_token} do
      struct = Struct.add(struct, :request, %{raw_headers: %{"cookie" => "ckns_atkn=#{access_token};ckns_id=1234;"}})
>>>>>>> 9953de70... formatting

      assert {
               :redirect,
               %Belfrage.Struct{
                 private: %Belfrage.Struct.Private{
                   authenticated: true,
                   session_token: ^access_token,
                   valid_session: false
                 }
               }
             } = UserSession.call([], struct)
    end

    test "expired access token will be redirected", %{struct: struct, expired_access_token: access_token} do
      struct = Struct.add(struct, :request, %{raw_headers: %{"cookie" => "ckns_atkn=#{access_token};ckns_id=1234;"}})

<<<<<<< HEAD
    assert {
             :redirect,
             %Belfrage.Struct{
               response: %Belfrage.Struct.Response{
                 headers: %{
                   "location" =>
                     "https://session.test.bbc.co.uk/account?ptrt=http%3A%2F%2Fbbc.co.uk%2Fsearch%3Fq=5tr%21ctly+c0m3+d%40nc%21nG",
                   "x-bbc-no-scheme-rewrite" => "1",
                   "cache-control" => "public, stale-while-revalidate=10, max-age=60"
<<<<<<< HEAD
=======
>>>>>>> c0fa8764... Added redirect for invalid or expired token
=======
      assert {
               :redirect,
               %Belfrage.Struct{
                 response: %Belfrage.Struct.Response{
                   headers: %{
                     "location" =>
                       "https://session.test.bbc.co.uk/account?ptrt=http%3A%2F%2Fbbc.co.uk%2Fsearch%3Fq=5tr%21ctly+c0m3+d%40nc%21nG",
                     "x-bbc-no-scheme-rewrite" => "1",
                     "cache-control" => "public, stale-while-revalidate=10, max-age=60"
                   }
>>>>>>> 9953de70... formatting
>>>>>>> aeef47e2... formatting
                 }
               }
             } = UserSession.call([], struct)
    end

<<<<<<< HEAD
  test "an invalid token header", %{struct: struct, invalid_access_token_header: access_token} do
    struct = Struct.add(struct, :request, %{raw_headers: %{"cookie" => "ckns_atkn=#{access_token};ckns_id=1234;"}})

=======
<<<<<<< HEAD
<<<<<<< HEAD
    test "expired access token will be redirected", %{struct: struct, expired_access_token: access_token} do
      struct = Struct.add(struct, :request, %{raw_headers: %{"cookie" => "ckns_atkn=#{access_token};ckns_id=1234;"}})

<<<<<<< HEAD
      assert {
               :redirect,
               %Belfrage.Struct{
                 response: %Belfrage.Struct.Response{
                   headers: %{
                     "location" =>
                       "https://session.test.bbc.co.uk/account?ptrt=http%3A%2F%2Fbbc.co.uk%2Fsearch%3Fq=5tr%21ctly+c0m3+d%40nc%21nG",
                     "x-bbc-no-scheme-rewrite" => "1",
                     "cache-control" => "public, stale-while-revalidate=10, max-age=60"
                   }
                 }
               }
             } = UserSession.call([], struct)
    end

    test "a malformed access token", %{struct: struct, malformed_access_token: access_token} do
      struct = Struct.add(struct, :request, %{raw_headers: %{"cookie" => "ckns_atkn=#{access_token};ckns_id=1234;"}})

      assert {
               :redirect,
               %Belfrage.Struct{
                 private: %Belfrage.Struct.Private{
                   authenticated: true,
                   session_token: ^access_token,
                   valid_session: false
=======
=======
  test "an invalid token header", %{struct: struct, invalid_access_token_header: access_token} do
    struct = Struct.add(struct, :request, %{raw_headers: %{"cookie" => "ckns_atkn=#{access_token};ckns_id=1234;"}})

<<<<<<< HEAD
>>>>>>> c0fa8764... Added redirect for invalid or expired token
=======
    test "a malformed access token", %{struct: struct, malformed_access_token: access_token} do
      struct = Struct.add(struct, :request, %{raw_headers: %{"cookie" => "ckns_atkn=#{access_token};ckns_id=1234;"}})

<<<<<<< HEAD
<<<<<<< HEAD
>>>>>>> 9953de70... formatting
      run_fn = fn ->
        assert {
                 :ok,
                 %Belfrage.Struct{
                   private: %Belfrage.Struct.Private{
                     authenticated: true,
                     session_token: ^access_token,
                     valid_session: false
                   }
>>>>>>> b69423d0... move token error logging to user_session transformer
                 }
               } = UserSession.call([], struct)
      end

      assert capture_log(run_fn) =~ ~s(Malformed JWT)
    end
=======
>>>>>>> aeef47e2... formatting
    assert {
             :redirect,
             %Belfrage.Struct{
               private: %Belfrage.Struct.Private{
                 authenticated: true,
                 session_token: ^access_token,
                 valid_session: false
=======
      assert {
               :redirect,
               %Belfrage.Struct{
                 private: %Belfrage.Struct.Private{
                   authenticated: true,
                   session_token: ^access_token,
                   valid_session: false
                 }
>>>>>>> a0f1428f... formatting
               }
             } = UserSession.call([], struct)
    end

    test "a malformed access token will be redirected", %{struct: struct, malformed_access_token: access_token} do
      struct = Struct.add(struct, :request, %{raw_headers: %{"cookie" => "ckns_atkn=#{access_token};ckns_id=1234;"}})

<<<<<<< HEAD
=======
<<<<<<< HEAD
<<<<<<< HEAD
    test "a malformed access token will be redirected", %{struct: struct, malformed_access_token: access_token} do
      struct = Struct.add(struct, :request, %{raw_headers: %{"cookie" => "ckns_atkn=#{access_token};ckns_id=1234;"}})

<<<<<<< HEAD
=======
>>>>>>> 9953de70... formatting
      assert {
               :redirect,
               %Belfrage.Struct{
                 response: %Belfrage.Struct.Response{
                   headers: %{
                     "location" =>
                       "https://session.test.bbc.co.uk/account?ptrt=http%3A%2F%2Fbbc.co.uk%2Fsearch%3Fq=5tr%21ctly+c0m3+d%40nc%21nG",
                     "x-bbc-no-scheme-rewrite" => "1",
                     "cache-control" => "public, stale-while-revalidate=10, max-age=60"
                   }
<<<<<<< HEAD
                 }
               }
             } = UserSession.call([], struct)
    end

    test "an invalid token header", %{struct: struct, invalid_access_token_header: access_token} do
      struct = Struct.add(struct, :request, %{raw_headers: %{"cookie" => "ckns_atkn=#{access_token};ckns_id=1234;"}})

      assert {
               :redirect,
               %Belfrage.Struct{
                 private: %Belfrage.Struct.Private{
                   authenticated: true,
                   session_token: ^access_token,
                   valid_session: false
=======
=======
>>>>>>> aeef47e2... formatting
    assert {
             :redirect,
             %Belfrage.Struct{
               response: %Belfrage.Struct.Response{
                 headers: %{
                   "location" =>
                     "https://session.test.bbc.co.uk/account?ptrt=http%3A%2F%2Fbbc.co.uk%2Fsearch%3Fq=5tr%21ctly+c0m3+d%40nc%21nG",
                   "x-bbc-no-scheme-rewrite" => "1",
                   "cache-control" => "public, stale-while-revalidate=10, max-age=60"
=======
>>>>>>> 9953de70... formatting
                 }
               }
<<<<<<< HEAD
             }
           } = UserSession.call([], struct)
  end
<<<<<<< HEAD
=======
>>>>>>> 250b0a2b... Added redirect for invalid or expired token
=======
             } = UserSession.call([], struct)
    end
>>>>>>> a0f1428f... formatting
>>>>>>> aeef47e2... formatting

    test "an invalid token header", %{struct: struct, invalid_access_token_header: access_token} do
      struct = Struct.add(struct, :request, %{raw_headers: %{"cookie" => "ckns_atkn=#{access_token};ckns_id=1234;"}})

<<<<<<< HEAD
=======
<<<<<<< HEAD
<<<<<<< HEAD
>>>>>>> c0fa8764... Added redirect for invalid or expired token
=======
<<<<<<< HEAD
>>>>>>> 9953de70... formatting
      run_fn = fn ->
        assert {
                 :ok,
                 %Belfrage.Struct{
                   private: %Belfrage.Struct.Private{
                     authenticated: true,
                     session_token: ^access_token,
                     valid_session: false
                   }
<<<<<<< HEAD
>>>>>>> b69423d0... move token error logging to user_session transformer
=======
=======
>>>>>>> aeef47e2... formatting
    run_fn = fn ->
=======
>>>>>>> a0f1428f... formatting
      assert {
               :redirect,
               %Belfrage.Struct{
                 private: %Belfrage.Struct.Private{
                   authenticated: true,
                   session_token: ^access_token,
                   valid_session: false
                 }
               } = UserSession.call([], struct)
      end

      assert capture_log(run_fn) =~ ~s(Invalid token header)
    end

<<<<<<< HEAD
=======
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 9953de70... formatting
    test "an invalid token header will be redirected", %{struct: struct, invalid_access_token_header: access_token} do
      struct = Struct.add(struct, :request, %{raw_headers: %{"cookie" => "ckns_atkn=#{access_token};ckns_id=1234;"}})

      assert {
               :redirect,
               %Belfrage.Struct{
                 response: %Belfrage.Struct.Response{
                   headers: %{
                     "location" =>
                       "https://session.test.bbc.co.uk/account?ptrt=http%3A%2F%2Fbbc.co.uk%2Fsearch%3Fq=5tr%21ctly+c0m3+d%40nc%21nG",
                     "x-bbc-no-scheme-rewrite" => "1",
                     "cache-control" => "public, stale-while-revalidate=10, max-age=60"
                   }
                 }
               }
             } = UserSession.call([], struct)
    end

    test "an invalid token issuer", %{struct: struct, invalid_token_issuer: access_token} do
<<<<<<< HEAD
=======
=======
      struct = Struct.add(struct, :request, %{raw_headers: %{"cookie" => "ckns_atkn=#{access_token};ckns_id=1234;"}})

      run_fn = fn ->
        assert {
                 :redirect,
                 %Belfrage.Struct{
                   private: %Belfrage.Struct.Private{
                     authenticated: true,
                     session_token: ^access_token,
                     valid_session: false
                   }
                 }
               } = UserSession.call([], struct)
      end

      assert capture_log(run_fn) =~ ~s("claim":"iss")
      assert capture_log(run_fn) =~ ~s(Claim validation failed)
    end

>>>>>>> 9953de70... formatting
>>>>>>> aeef47e2... formatting
    test "an invalid token issuer will be redirected", %{struct: struct, invalid_token_issuer: access_token} do
      struct = Struct.add(struct, :request, %{raw_headers: %{"cookie" => "ckns_atkn=#{access_token};ckns_id=1234;"}})

      run_fn = fn ->
        assert {
                 :redirect,
                 %Belfrage.Struct{
                   response: %Belfrage.Struct.Response{
                     headers: %{
                       "location" =>
                         "https://session.test.bbc.co.uk/account?ptrt=http%3A%2F%2Fbbc.co.uk%2Fsearch%3Fq=5tr%21ctly+c0m3+d%40nc%21nG",
                       "x-bbc-no-scheme-rewrite" => "1",
                       "cache-control" => "public, stale-while-revalidate=10, max-age=60"
                     }
                   }
                 }
               } = UserSession.call([], struct)
      end

      assert capture_log(run_fn) =~ ~s("claim":"iss")
      assert capture_log(run_fn) =~ ~s(Claim validation failed)
    end

    test "invalid token aud", %{struct: struct, invalid_token_aud: access_token} do
      struct = Struct.add(struct, :request, %{raw_headers: %{"cookie" => "ckns_atkn=#{access_token};ckns_id=1234;"}})

      run_fn = fn ->
        assert {
                 :redirect,
                 %Belfrage.Struct{
                   private: %Belfrage.Struct.Private{
                     authenticated: true,
                     session_token: ^access_token,
                     valid_session: false
                   }
                 }
               } = UserSession.call([], struct)
      end

      assert capture_log(run_fn) =~ ~s("claim":"aud")
      assert capture_log(run_fn) =~ ~s(Claim validation failed)
    end

    test "invalid token aud will be redirected", %{struct: struct, invalid_token_aud: access_token} do
      struct = Struct.add(struct, :request, %{raw_headers: %{"cookie" => "ckns_atkn=#{access_token};ckns_id=1234;"}})

      run_fn = fn ->
        assert {
                 :redirect,
                 %Belfrage.Struct{
                   response: %Belfrage.Struct.Response{
                     headers: %{
                       "location" =>
                         "https://session.test.bbc.co.uk/account?ptrt=http%3A%2F%2Fbbc.co.uk%2Fsearch%3Fq=5tr%21ctly+c0m3+d%40nc%21nG",
                       "x-bbc-no-scheme-rewrite" => "1",
                       "cache-control" => "public, stale-while-revalidate=10, max-age=60"
                     }
                   }
                 }
               } = UserSession.call([], struct)
      end

      assert capture_log(run_fn) =~ ~s("claim":"aud")
      assert capture_log(run_fn) =~ ~s(Claim validation failed)
    end

    test "invalid token tokenName claim", %{struct: struct, invalid_token_name: access_token} do
      struct = Struct.add(struct, :request, %{raw_headers: %{"cookie" => "ckns_atkn=#{access_token};ckns_id=1234;"}})

      run_fn = fn ->
        assert {
                 :redirect,
                 %Belfrage.Struct{
                   private: %Belfrage.Struct.Private{
                     authenticated: true,
                     session_token: ^access_token,
                     valid_session: false
                   }
                 }
               } = UserSession.call([], struct)
      end

      assert capture_log(run_fn) =~ ~s("claim":"tokenName")
      assert capture_log(run_fn) =~ ~s(Claim validation failed)
    end

    test "invalid token tokenName claim will be redirected", %{struct: struct, invalid_token_name: access_token} do
      struct = Struct.add(struct, :request, %{raw_headers: %{"cookie" => "ckns_atkn=#{access_token};ckns_id=1234;"}})

      run_fn = fn ->
        assert {
                 :redirect,
                 %Belfrage.Struct{
                   response: %Belfrage.Struct.Response{
                     headers: %{
                       "location" =>
                         "https://session.test.bbc.co.uk/account?ptrt=http%3A%2F%2Fbbc.co.uk%2Fsearch%3Fq=5tr%21ctly+c0m3+d%40nc%21nG",
                       "x-bbc-no-scheme-rewrite" => "1",
                       "cache-control" => "public, stale-while-revalidate=10, max-age=60"
                     }
                   }
                 }
               } = UserSession.call([], struct)
      end

      assert capture_log(run_fn) =~ ~s("claim":"tokenName")
      assert capture_log(run_fn) =~ ~s(Claim validation failed)
    end
  end

  describe "no public keys" do
    setup do
      :sys.replace_state(Belfrage.Authentication.Jwk, fn _existing_state -> %{"keys" => []} end)

      on_exit(fn ->
        :sys.replace_state(Belfrage.Authentication.Jwk, fn _existing_state -> %{"keys" => Fixtures.AuthToken.keys()} end)
      end)
    end

    test "when public key not found, but the access token is valid", %{struct: struct} do
      access_token = Fixtures.AuthToken.valid_access_token()

      struct = Struct.add(struct, :request, %{raw_headers: %{"cookie" => "ckns_atkn=#{access_token};ckns_id=1234;"}})

      assert {
               :redirect,
               %Belfrage.Struct{
                 private: %Belfrage.Struct.Private{
                   authenticated: true,
                   session_token: ^access_token,
                   valid_session: false
                 }
               } = UserSession.call([], struct)
      end

      assert capture_log(run_fn) =~ ~s(Public key not found)
      assert capture_log(run_fn) =~ ~s("key_id":"SOME_EC_KEY_ID")
      assert capture_log(run_fn) =~ ~s("alg":"ES256")
    end

    test "when public key not found, but the access token is valid will be redirected", %{struct: struct} do
      access_token = Fixtures.AuthToken.valid_access_token()

      struct = Struct.add(struct, :request, %{raw_headers: %{"cookie" => "ckns_atkn=#{access_token};ckns_id=1234;"}})

      assert {
               :redirect,
               %Belfrage.Struct{
                 response: %Belfrage.Struct.Response{
                   headers: %{
                     "location" =>
                       "https://session.test.bbc.co.uk/account?ptrt=http%3A%2F%2Fbbc.co.uk%2Fsearch%3Fq=5tr%21ctly+c0m3+d%40nc%21nG",
                     "x-bbc-no-scheme-rewrite" => "1",
                     "cache-control" => "public, stale-while-revalidate=10, max-age=60"
                   }
                 }
               }
             } = UserSession.call([], struct)
    end
  end
end
