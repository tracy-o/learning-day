defmodule Belfrage.Allowlist.CookiesTest do
  use ExUnit.Case, async: true
  alias Belfrage.Struct
  alias Belfrage.Allowlist.Cookies

  describe "when a wildcard is used" do
    test "all provided cookies are added to the request cookie section" do
      struct = %Struct{
        request: %Struct.Request{
          raw_headers: %{"cookie" => "best=bourbon;worst=custard-creams"}
        },
        private: %Struct.Private{
          cookie_allowlist: "*"
        }
      }

      assert %Struct{
               request: %Struct.Request{
                 cookies: %{"best" => "bourbon", "worst" => "custard-creams"}
               }
             } = Cookies.filter(struct)
    end

    test "when an empty cookie header is provided" do
      struct = %Struct{
        request: %Struct.Request{
          raw_headers: %{"cookie" => ""}
        },
        private: %Struct.Private{
          cookie_allowlist: "*"
        }
      }

      assert %{} == Cookies.filter(struct).request.cookies
    end

    test "when an invalid cookie header is provided" do
      struct = %Struct{
        request: %Struct.Request{
          raw_headers: %{"cookie" => "foo"}
        },
        private: %Struct.Private{
          cookie_allowlist: "*"
        }
      }

      assert %{} == Cookies.filter(struct).request.cookies
    end

    test "when no cookie header is provided" do
      struct = %Struct{
        request: %Struct.Request{
          raw_headers: %{}
        },
        private: %Struct.Private{
          cookie_allowlist: "*"
        }
      }

      assert %{} == Cookies.filter(struct).request.cookies
    end
  end

  describe "when a cookies allowlist is provided" do
    test "only allowed cookies are added to the cookie list" do
      struct = %Struct{
        request: %Struct.Request{
          raw_headers: %{"cookie" => "best=bourbon;worst=custard-creams"}
        },
        private: %Struct.Private{
          cookie_allowlist: ["best"]
        }
      }

      assert %Struct{
               request: %Struct.Request{
                 cookies: %{"best" => "bourbon"}
               }
             } = Cookies.filter(struct)
    end

    test "when an empty cookie header is provided" do
      struct = %Struct{
        request: %Struct.Request{
          raw_headers: %{"cookie" => ""}
        },
        private: %Struct.Private{
          cookie_allowlist: ["best"]
        }
      }

      assert %{} == Cookies.filter(struct).request.cookies
    end

    test "when an invalid cookie header is provided" do
      struct = %Struct{
        request: %Struct.Request{
          raw_headers: %{"cookie" => "foo"}
        },
        private: %Struct.Private{
          cookie_allowlist: ["best"]
        }
      }

      assert %{} == Cookies.filter(struct).request.cookies
    end

    test "when no cookie header is provided" do
      struct = %Struct{
        request: %Struct.Request{
          raw_headers: %{}
        },
        private: %Struct.Private{
          cookie_allowlist: ["best"]
        }
      }

      assert %{} == Cookies.filter(struct).request.cookies
    end
  end
end
