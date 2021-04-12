defmodule Belfrage.Transformers.UserSessionTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  import ExUnit.CaptureLog

  alias Belfrage.Authentication.FlagpoleMock
  alias Belfrage.Struct
  alias Belfrage.Transformers.UserSession

  @authenticated_only_session_state %Struct.Private{authenticated: true, session_token: nil, valid_session: false}
  @unauthenticated_session_state %Struct.Private{authenticated: false, session_token: nil, valid_session: false}

  @token Fixtures.AuthToken.valid_access_token()

  def enable_personalisation_dial() do
    stub(Belfrage.Dials.ServerMock, :state, fn :personalisation ->
      Belfrage.Dials.Personalisation.transform("on")
    end)
  end

  def disable_personalisation_dial() do
    stub(Belfrage.Dials.ServerMock, :state, fn :personalisation ->
      Belfrage.Dials.Personalisation.transform("off")
    end)
  end

  setup do
    enable_personalisation_dial()

    start_supervised!(Belfrage.Authentication.Jwk)

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

  describe "when personalisation dial is 'on', idcta flagpole is true" do
    setup do
      expect(FlagpoleMock, :state, fn -> true end)
      :ok
    end

    test "'x-id-oidc-signedin' header set to '1' only will be redirected", %{struct: struct} do
      struct = Struct.add(struct, :request, %{raw_headers: %{"x-id-oidc-signedin" => "1"}})

      assert {
               :redirect,
               %Struct{
                 private: @authenticated_only_session_state,
                 response: %Struct.Response{
                   headers: %{
                     "location" =>
                       "https://session.test.bbc.co.uk/session?ptrt=http%3A%2F%2Fbbc.co.uk%2Fsearch%3Fq=5tr%21ctly+c0m3+d%40nc%21nG",
                     "x-bbc-no-scheme-rewrite" => "1",
                     "cache-control" => "private"
                   }
                 }
               }
             } = UserSession.call([], struct)
    end

    test "'x-id-oidc-signedin' header set to '1' and other cookies will be redirected", %{struct: struct} do
      struct =
        Struct.add(struct, :request, %{
          cookies: %{"ckns_abc" => "def", "foo" => "bar"},
          raw_headers: %{"x-id-oidc-signedin" => "1"}
        })

      assert {
               :redirect,
               %Struct{
                 private: @authenticated_only_session_state,
                 response: %Struct.Response{
                   headers: %{
                     "location" =>
                       "https://session.test.bbc.co.uk/session?ptrt=http%3A%2F%2Fbbc.co.uk%2Fsearch%3Fq=5tr%21ctly+c0m3+d%40nc%21nG",
                     "x-bbc-no-scheme-rewrite" => "1",
                     "cache-control" => "private"
                   }
                 }
               }
             } = UserSession.call([], struct)
    end

    test "No token and 'ckns_id' cookie without signedin header will be redirected", %{struct: struct} do
      struct =
        Struct.add(struct, :request, %{
          cookies: %{"ckns_abc" => "def", "foo" => "bar", "ckns_id" => "123"}
        })

      assert {
               :redirect,
               %Struct{
                 private: @authenticated_only_session_state,
                 response: %Struct.Response{
                   headers: %{
                     "location" =>
                       "https://session.test.bbc.co.uk/session?ptrt=http%3A%2F%2Fbbc.co.uk%2Fsearch%3Fq=5tr%21ctly+c0m3+d%40nc%21nG",
                     "x-bbc-no-scheme-rewrite" => "1",
                     "cache-control" => "private"
                   }
                 }
               }
             } = UserSession.call([], struct)
    end

    test "cookie for 'ckns_atkn' only, 'x-id-oidc-signedin' header not set will not be authenticated", %{struct: struct} do
      struct = Struct.add(struct, :request, %{cookies: %{"ckns_atkn" => "1234"}})
      assert {:ok, %Struct{private: @unauthenticated_session_state}} = UserSession.call([], struct)
    end

    test "'x-id-oidc-signedin' header set to '0' will not be authenticated", %{struct: struct} do
      struct =
        Struct.add(struct, :request, %{cookies: %{"ckns_abc" => "def"}, raw_headers: %{"x-id-oidc-signedin" => "0"}})

      assert {:ok, %Struct{private: @unauthenticated_session_state}} = UserSession.call([], struct)
    end

    test "cookie without 'ckns_atkn' will not be authenticated", %{struct: struct} do
      struct = Struct.add(struct, :request, %{cookies: %{"ckns_abc" => "def"}})
      assert {:ok, %Struct{private: @unauthenticated_session_state}} = UserSession.call([], struct)
    end

    test "empty cookie will not be authenticated", %{struct: struct} do
      struct = Struct.add(struct, :request, %{cookies: %{}})
      assert {:ok, %Struct{private: @unauthenticated_session_state}} = UserSession.call([], struct)
    end

    test "'x-id-oidc-signedin' header set to '1' and valid `ckns_atkn` cookie will be authenticated" do
      struct = %Struct{
        request: %Struct.Request{
          cookies: %{"ckns_abc" => "def", "ckns_atkn" => @token, "foo" => "bar"},
          raw_headers: %{"x-id-oidc-signedin" => "1"},
          host: "bbc.co.uk"
        }
      }

      assert {
               :ok,
               %Struct{
                 private: %Struct.Private{
                   authenticated: true,
                   session_token: @token,
                   valid_session: true
                 }
               }
             } = UserSession.call([], struct)
    end

    test "valid `ckns_atkn` and 'ckns_id' cookies will be authenticated" do
      struct = %Struct{
        request: %Struct.Request{
          cookies: %{"ckns_abc" => "def", "ckns_atkn" => @token, "foo" => "bar", "ckns_id" => "123"},
          host: "bbc.co.uk"
        }
      }

      assert {
               :ok,
               %Struct{
                 private: %Struct.Private{
                   authenticated: true,
                   session_token: @token,
                   valid_session: true
                 }
               }
             } = UserSession.call([], struct)
    end
  end

  describe "when personalisation dial is 'on', idcta flagpole is false" do
    setup do
      expect(FlagpoleMock, :state, fn -> false end)
      :ok
    end

    test "'x-id-oidc-signedin' header set to '1' and other cookies will not be redirected", %{struct: struct} do
      struct =
        Struct.add(struct, :request, %{
          cookies: %{"ckns_abc" => "def", "foo" => "bar"},
          raw_headers: %{"x-id-oidc-signedin" => "1"}
        })

      assert {:ok, %Struct{private: @unauthenticated_session_state}} = UserSession.call([], struct)
    end

    test "'x-id-oidc-signedin' header set to '1' only will not be redirected", %{struct: struct} do
      struct = Struct.add(struct, :request, %{raw_headers: %{"x-id-oidc-signedin" => "1"}})
      assert {:ok, %Struct{private: @unauthenticated_session_state}} = UserSession.call([], struct)
    end

    test "'x-id-oidc-signedin' header set to '1' and valid `ckns_atkn` cookie will not be authenticated" do
      struct = %Struct{
        request: %Struct.Request{
          cookies: %{"ckns_abc" => "def", "ckns_atkn" => @token, "foo" => "bar"},
          raw_headers: %{"x-id-oidc-signedin" => "1"},
          host: "bbc.co.uk"
        }
      }

      assert {:ok, %Struct{private: @unauthenticated_session_state}} = UserSession.call([], struct)
    end
  end

  describe "when personalisation dial is in 'off' state" do
    setup do
      disable_personalisation_dial()

      :ok
    end

    test "does not call flagpole state" do
      expect(FlagpoleMock, :state, 0, fn -> flunk("Should not be called") end)

      struct = %Struct{
        request: %Struct.Request{
          cookies: %{"ckns_abc" => "def", "ckns_atkn" => @token, "foo" => "bar"},
          raw_headers: %{"x-id-oidc-signedin" => "1"},
          host: "bbc.co.uk"
        }
      }

      UserSession.call([], struct)
    end

    test "request remains unauthenticated, despite valid cookie and header" do
      struct = %Struct{
        request: %Struct.Request{
          cookies: %{"ckns_abc" => "def", "ckns_atkn" => @token, "foo" => "bar"},
          raw_headers: %{"x-id-oidc-signedin" => "1"},
          host: "bbc.co.uk"
        }
      }

      assert {
               :ok,
               %Struct{
                 private: %Struct.Private{
                   authenticated: false,
                   session_token: nil,
                   valid_session: false
                 }
               }
             } = UserSession.call([], struct)
    end
  end

  describe "when host is .com" do
    setup do
      FlagpoleMock |> expect(:state, fn -> true end)
      :ok
    end

    test "request remains unauthenticated, despite valid cookie and header" do
      struct = %Struct{
        request: %Struct.Request{
          cookies: %{"ckns_abc" => "def", "ckns_atkn" => @token, "foo" => "bar"},
          raw_headers: %{"x-id-oidc-signedin" => "1"},
          host: "bbc.com"
        }
      }

      assert {:ok, %Struct{private: @unauthenticated_session_state}} = UserSession.call([], struct)
    end
  end

  describe "unhappy access token paths (when public keys exist)" do
    setup do
      FlagpoleMock |> expect(:state, fn -> true end)

      %{
        valid_access_token: Fixtures.AuthToken.valid_access_token(),
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
      struct =
        Struct.add(%Struct{}, :request, %{
          cookies: %{"ckns_atkn" => access_token},
          raw_headers: %{"x-id-oidc-signedin" => "1"},
          host: "bbc.co.uk"
        })

      assert {
               :ok,
               %Struct{
                 private: %Struct.Private{
                   authenticated: true,
                   session_token: ^access_token,
                   valid_session: true
                 }
               }
             } = UserSession.call([], struct)
    end

    test "invalid payload access token", %{struct: struct, invalid_payload_access_token: access_token} do
      struct =
        Struct.add(struct, :request, %{
          cookies: %{"ckns_atkn" => access_token},
          raw_headers: %{"x-id-oidc-signedin" => "1"},
          host: "bbc.co.uk"
        })

      assert {
               :redirect,
               %Struct{
                 private: %Struct.Private{
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
      struct =
        Struct.add(struct, :request, %{
          cookies: %{"ckns_atkn" => access_token},
          raw_headers: %{"x-id-oidc-signedin" => "1"}
        })

      assert {
               :redirect,
               %Struct{
                 response: %Struct.Response{
                   headers: %{
                     "location" =>
                       "https://session.test.bbc.co.uk/session?ptrt=http%3A%2F%2Fbbc.co.uk%2Fsearch%3Fq=5tr%21ctly+c0m3+d%40nc%21nG",
                     "x-bbc-no-scheme-rewrite" => "1",
                     "cache-control" => "private"
                   }
                 }
               }
             } = UserSession.call([], struct)
    end

    test "invalid access token", %{struct: struct, invalid_access_token: access_token} do
      struct =
        Struct.add(struct, :request, %{
          cookies: %{"ckns_atkn" => access_token},
          raw_headers: %{"x-id-oidc-signedin" => "1"}
        })

      assert {
               :redirect,
               %Struct{
                 private: %Struct.Private{
                   authenticated: true,
                   session_token: ^access_token,
                   valid_session: false
                 }
               }
             } = UserSession.call([], struct)
    end

    test "invalid access token will be redirected", %{struct: struct, invalid_access_token: access_token} do
      struct =
        Struct.add(struct, :request, %{
          cookies: %{"ckns_atkn" => access_token},
          raw_headers: %{"x-id-oidc-signedin" => "1"}
        })

      assert {
               :redirect,
               %Struct{
                 response: %Struct.Response{
                   headers: %{
                     "location" =>
                       "https://session.test.bbc.co.uk/session?ptrt=http%3A%2F%2Fbbc.co.uk%2Fsearch%3Fq=5tr%21ctly+c0m3+d%40nc%21nG",
                     "x-bbc-no-scheme-rewrite" => "1",
                     "cache-control" => "private"
                   }
                 }
               }
             } = UserSession.call([], struct)
    end

    test "expired access token", %{struct: struct, expired_access_token: access_token} do
      struct =
        Struct.add(struct, :request, %{
          cookies: %{"ckns_atkn" => access_token},
          raw_headers: %{"x-id-oidc-signedin" => "1"}
        })

      assert {
               :redirect,
               %Struct{
                 private: %Struct.Private{
                   authenticated: true,
                   session_token: ^access_token,
                   valid_session: false
                 }
               }
             } = UserSession.call([], struct)
    end

    test "expired access token will be redirected", %{struct: struct, expired_access_token: access_token} do
      struct =
        Struct.add(struct, :request, %{
          cookies: %{"ckns_atkn" => access_token},
          raw_headers: %{"x-id-oidc-signedin" => "1"}
        })

      assert {
               :redirect,
               %Struct{
                 response: %Struct.Response{
                   headers: %{
                     "location" =>
                       "https://session.test.bbc.co.uk/session?ptrt=http%3A%2F%2Fbbc.co.uk%2Fsearch%3Fq=5tr%21ctly+c0m3+d%40nc%21nG",
                     "x-bbc-no-scheme-rewrite" => "1",
                     "cache-control" => "private"
                   }
                 }
               }
             } = UserSession.call([], struct)
    end

    test "nearly expired access token", %{struct: struct, valid_access_token: access_token} do
      struct =
        Struct.add(struct, :request, %{
          cookies: %{"ckns_atkn" => access_token},
          raw_headers: %{"x-id-oidc-signedin" => "1"}
        })

      expect(Belfrage.Authentication.Validator.ExpiryMock, :valid?, fn _threshold, _expiry ->
        false
      end)

      assert {
               :redirect,
               %Struct{
                 private: %Struct.Private{
                   authenticated: true,
                   session_token: ^access_token,
                   valid_session: false
                 }
               }
             } = UserSession.call([], struct)
    end

    test "nearly expired access token will be redirected", %{struct: struct, valid_access_token: access_token} do
      struct =
        Struct.add(struct, :request, %{
          cookies: %{"ckns_atkn" => access_token},
          raw_headers: %{"x-id-oidc-signedin" => "1"}
        })

      expect(Belfrage.Authentication.Validator.ExpiryMock, :valid?, fn _threshold, _expiry ->
        false
      end)

      assert {
               :redirect,
               %Struct{
                 response: %Struct.Response{
                   headers: %{
                     "location" =>
                       "https://session.test.bbc.co.uk/session?ptrt=http%3A%2F%2Fbbc.co.uk%2Fsearch%3Fq=5tr%21ctly+c0m3+d%40nc%21nG",
                     "x-bbc-no-scheme-rewrite" => "1",
                     "cache-control" => "private"
                   }
                 }
               }
             } = UserSession.call([], struct)
    end

    test "a malformed access token", %{struct: struct, malformed_access_token: access_token} do
      struct =
        Struct.add(struct, :request, %{
          cookies: %{"ckns_atkn" => access_token},
          raw_headers: %{"x-id-oidc-signedin" => "1"}
        })

      assert {
               :redirect,
               %Struct{
                 private: %Struct.Private{
                   authenticated: true,
                   session_token: ^access_token,
                   valid_session: false
                 }
               }
             } = UserSession.call([], struct)
    end

    test "a malformed access token will be redirected", %{struct: struct, malformed_access_token: access_token} do
      struct =
        Struct.add(struct, :request, %{
          cookies: %{"ckns_atkn" => access_token},
          raw_headers: %{"x-id-oidc-signedin" => "1"}
        })

      assert {
               :redirect,
               %Struct{
                 response: %Struct.Response{
                   headers: %{
                     "location" =>
                       "https://session.test.bbc.co.uk/session?ptrt=http%3A%2F%2Fbbc.co.uk%2Fsearch%3Fq=5tr%21ctly+c0m3+d%40nc%21nG",
                     "x-bbc-no-scheme-rewrite" => "1",
                     "cache-control" => "private"
                   }
                 }
               }
             } = UserSession.call([], struct)
    end

    test "an invalid token header", %{struct: struct, invalid_access_token_header: access_token} do
      struct =
        Struct.add(struct, :request, %{
          cookies: %{"ckns_atkn" => access_token},
          raw_headers: %{"x-id-oidc-signedin" => "1"}
        })

      run_fn = fn ->
        assert {
                 :redirect,
                 %Struct{
                   private: %Struct.Private{
                     authenticated: true,
                     session_token: ^access_token,
                     valid_session: false
                   }
                 }
               } = UserSession.call([], struct)
      end

      assert capture_log(run_fn) =~ ~s(Invalid token header)
    end

    test "an invalid token header will be redirected", %{struct: struct, invalid_access_token_header: access_token} do
      struct =
        Struct.add(struct, :request, %{
          cookies: %{"ckns_atkn" => access_token},
          raw_headers: %{"x-id-oidc-signedin" => "1"}
        })

      assert {
               :redirect,
               %Struct{
                 response: %Struct.Response{
                   headers: %{
                     "location" =>
                       "https://session.test.bbc.co.uk/session?ptrt=http%3A%2F%2Fbbc.co.uk%2Fsearch%3Fq=5tr%21ctly+c0m3+d%40nc%21nG",
                     "x-bbc-no-scheme-rewrite" => "1",
                     "cache-control" => "private"
                   }
                 }
               }
             } = UserSession.call([], struct)
    end

    test "an invalid token issuer", %{struct: struct, invalid_token_issuer: access_token} do
      FlagpoleMock |> expect(:state, fn -> true end)

      struct =
        Struct.add(struct, :request, %{
          cookies: %{"ckns_atkn" => access_token},
          raw_headers: %{"x-id-oidc-signedin" => "1"}
        })

      run_fn = fn ->
        assert {
                 :redirect,
                 %Struct{
                   private: %Struct.Private{
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

    test "an invalid token issuer will be redirected", %{struct: struct, invalid_token_issuer: access_token} do
      FlagpoleMock |> expect(:state, fn -> true end)

      struct =
        Struct.add(struct, :request, %{
          cookies: %{"ckns_atkn" => access_token},
          raw_headers: %{"x-id-oidc-signedin" => "1"}
        })

      run_fn = fn ->
        assert {
                 :redirect,
                 %Struct{
                   response: %Struct.Response{
                     headers: %{
                       "location" =>
                         "https://session.test.bbc.co.uk/session?ptrt=http%3A%2F%2Fbbc.co.uk%2Fsearch%3Fq=5tr%21ctly+c0m3+d%40nc%21nG",
                       "x-bbc-no-scheme-rewrite" => "1",
                       "cache-control" => "private"
                     }
                   }
                 }
               } = UserSession.call([], struct)
      end

      assert capture_log(run_fn) =~ ~s("claim":"iss")
      assert capture_log(run_fn) =~ ~s(Claim validation failed)
    end

    test "invalid token aud", %{struct: struct, invalid_token_aud: access_token} do
      FlagpoleMock |> expect(:state, fn -> true end)

      struct =
        Struct.add(struct, :request, %{
          cookies: %{"ckns_atkn" => access_token},
          raw_headers: %{"x-id-oidc-signedin" => "1"}
        })

      run_fn = fn ->
        assert {
                 :redirect,
                 %Struct{
                   private: %Struct.Private{
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
      FlagpoleMock |> expect(:state, fn -> true end)

      struct =
        Struct.add(struct, :request, %{
          cookies: %{"ckns_atkn" => access_token},
          raw_headers: %{"x-id-oidc-signedin" => "1"}
        })

      run_fn = fn ->
        assert {
                 :redirect,
                 %Struct{
                   response: %Struct.Response{
                     headers: %{
                       "location" =>
                         "https://session.test.bbc.co.uk/session?ptrt=http%3A%2F%2Fbbc.co.uk%2Fsearch%3Fq=5tr%21ctly+c0m3+d%40nc%21nG",
                       "x-bbc-no-scheme-rewrite" => "1",
                       "cache-control" => "private"
                     }
                   }
                 }
               } = UserSession.call([], struct)
      end

      assert capture_log(run_fn) =~ ~s("claim":"aud")
      assert capture_log(run_fn) =~ ~s(Claim validation failed)
    end

    test "invalid token tokenName claim", %{struct: struct, invalid_token_name: access_token} do
      FlagpoleMock |> expect(:state, fn -> true end)

      struct =
        Struct.add(struct, :request, %{
          cookies: %{"ckns_atkn" => access_token},
          raw_headers: %{"x-id-oidc-signedin" => "1"}
        })

      run_fn = fn ->
        assert {
                 :redirect,
                 %Struct{
                   private: %Struct.Private{
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
      FlagpoleMock |> expect(:state, fn -> true end)

      struct =
        Struct.add(struct, :request, %{
          cookies: %{"ckns_atkn" => access_token},
          raw_headers: %{"x-id-oidc-signedin" => "1"}
        })

      run_fn = fn ->
        assert {
                 :redirect,
                 %Struct{
                   response: %Struct.Response{
                     headers: %{
                       "location" =>
                         "https://session.test.bbc.co.uk/session?ptrt=http%3A%2F%2Fbbc.co.uk%2Fsearch%3Fq=5tr%21ctly+c0m3+d%40nc%21nG",
                       "x-bbc-no-scheme-rewrite" => "1",
                       "cache-control" => "private"
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
      FlagpoleMock |> expect(:state, fn -> true end)
      :sys.replace_state(Belfrage.Authentication.Jwk, fn _existing_state -> %{"keys" => []} end)
    end

    test "when public key not found, but the access token is valid", %{struct: struct} do
      struct =
        Struct.add(struct, :request, %{
          cookies: %{"ckns_atkn" => @token},
          raw_headers: %{"x-id-oidc-signedin" => "1"}
        })

      run_fn = fn ->
        assert {
                 :redirect,
                 %Struct{
                   private: %Struct.Private{
                     authenticated: true,
                     session_token: @token,
                     valid_session: false
                   }
                 }
               } = UserSession.call([], struct)
      end

      assert capture_log(run_fn) =~ ~s(Public key not found)
    end

    test "when public key not found, but the access token is valid will be redirected", %{struct: struct} do
      struct =
        Struct.add(struct, :request, %{
          cookies: %{"ckns_atkn" => @token},
          raw_headers: %{"x-id-oidc-signedin" => "1"}
        })

      assert {
               :redirect,
               %Struct{
                 response: %Struct.Response{
                   headers: %{
                     "location" =>
                       "https://session.test.bbc.co.uk/session?ptrt=http%3A%2F%2Fbbc.co.uk%2Fsearch%3Fq=5tr%21ctly+c0m3+d%40nc%21nG",
                     "x-bbc-no-scheme-rewrite" => "1",
                     "cache-control" => "private"
                   }
                 }
               }
             } = UserSession.call([], struct)
    end
  end
end
