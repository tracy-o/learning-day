defmodule Belfrage.Allowlist.CookiesTest do
  use ExUnit.Case, async: true
  alias Belfrage.Envelope
  alias Belfrage.Allowlist.Cookies

  describe "when a wildcard is used" do
    test "all provided cookies are added to the request cookie section" do
      envelope = %Envelope{
        request: %Envelope.Request{
          raw_headers: %{"cookie" => "best=bourbon;worst=custard-creams"}
        },
        private: %Envelope.Private{
          cookie_allowlist: "*"
        }
      }

      assert %Envelope{
               request: %Envelope.Request{
                 cookies: %{"best" => "bourbon", "worst" => "custard-creams"}
               }
             } = Cookies.filter(envelope)
    end

    test "when an empty cookie header is provided" do
      envelope = %Envelope{
        request: %Envelope.Request{
          raw_headers: %{"cookie" => ""}
        },
        private: %Envelope.Private{
          cookie_allowlist: "*"
        }
      }

      assert %{} == Cookies.filter(envelope).request.cookies
    end

    test "when an invalid cookie header is provided" do
      envelope = %Envelope{
        request: %Envelope.Request{
          raw_headers: %{"cookie" => "foo"}
        },
        private: %Envelope.Private{
          cookie_allowlist: "*"
        }
      }

      assert %{} == Cookies.filter(envelope).request.cookies
    end

    test "when no cookie header is provided" do
      envelope = %Envelope{
        request: %Envelope.Request{
          raw_headers: %{}
        },
        private: %Envelope.Private{
          cookie_allowlist: "*"
        }
      }

      assert %{} == Cookies.filter(envelope).request.cookies
    end
  end

  describe "when a cookies allowlist is provided" do
    test "only allowed cookies are added to the cookie list" do
      envelope = %Envelope{
        request: %Envelope.Request{
          raw_headers: %{"cookie" => "best=bourbon;worst=custard-creams"}
        },
        private: %Envelope.Private{
          cookie_allowlist: ["best"]
        }
      }

      assert %Envelope{
               request: %Envelope.Request{
                 cookies: %{"best" => "bourbon"}
               }
             } = Cookies.filter(envelope)
    end

    test "when an empty cookie header is provided" do
      envelope = %Envelope{
        request: %Envelope.Request{
          raw_headers: %{"cookie" => ""}
        },
        private: %Envelope.Private{
          cookie_allowlist: ["best"]
        }
      }

      assert %{} == Cookies.filter(envelope).request.cookies
    end

    test "when an invalid cookie header is provided" do
      envelope = %Envelope{
        request: %Envelope.Request{
          raw_headers: %{"cookie" => "foo"}
        },
        private: %Envelope.Private{
          cookie_allowlist: ["best"]
        }
      }

      assert %{} == Cookies.filter(envelope).request.cookies
    end

    test "when no cookie header is provided" do
      envelope = %Envelope{
        request: %Envelope.Request{
          raw_headers: %{}
        },
        private: %Envelope.Private{
          cookie_allowlist: ["best"]
        }
      }

      assert %{} == Cookies.filter(envelope).request.cookies
    end
  end

  test "when no cookies allowlist is provided" do
    envelope = %Envelope{
      request: %Envelope.Request{
        raw_headers: %{"cookie" => "best=bourbon;worst=custard-creams"}
      },
      private: %Envelope.Private{
        cookie_allowlist: []
      }
    }

    assert %{} == Cookies.filter(envelope).request.cookies
  end
end
