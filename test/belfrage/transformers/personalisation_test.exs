defmodule Belfrage.Transformers.PersonalisationTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  import Belfrage.Test.PersonalisationHelper

  alias Belfrage.Struct
  alias Belfrage.Struct.{Request, Private}
  alias Belfrage.Transformers.Personalisation

  setup do
    struct =
      %Struct{
        request: %Request{
          path: "/search",
          scheme: :http,
          host: "bbc.co.uk",
          query_params: %{"q" => "5tr!ctly c0m3 d@nc!nG"}
        },
        private: %Private{
          personalised_request: true
        }
      }
      |> authenticate_request()

    %{struct: struct}
  end

  describe "call/2" do
    test "request is not personalised", %{struct: struct} do
      struct = Struct.add(struct, :private, %{personalised_request: false})
      assert Personalisation.call([], struct) == {:ok, struct}
    end

    test "user is not authenticated", %{struct: struct} do
      struct = deauthenticate_request(struct)
      assert {:ok, struct} = Personalisation.call([], struct)
      refute struct.user_session.authenticated
    end

    test "user is authenticated, session is invalid", %{struct: struct} do
      assert {:redirect, struct} = Personalisation.call([], struct)
      assert struct.user_session.authenticated
      refute struct.user_session.valid_session

      assert struct.response == %Struct.Response{
               http_status: 302,
               headers: %{
                 "location" =>
                   "https://session.test.bbc.co.uk/session?ptrt=http%3A%2F%2Fbbc.co.uk%2Fsearch%3Fq=5tr%21ctly+c0m3+d%40nc%21nG",
                 "x-bbc-no-scheme-rewrite" => "1",
                 "cache-control" => "private"
               },
               body: "Redirecting"
             }
    end

    test "user is authenticated, session is valid", %{struct: struct} do
      token = Fixtures.AuthToken.valid_access_token()
      struct = personalise_request(struct, token)

      assert {:ok, struct} = Personalisation.call([], struct)
      assert struct.user_session.authenticated
      assert struct.user_session.valid_session
      assert struct.user_session.session_token == token
    end
  end
end
