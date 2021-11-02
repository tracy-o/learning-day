defmodule Belfrage.Transformers.LanguageTest do
  use ExUnit.Case

  alias Belfrage.Transformers.Language
  alias Belfrage.Struct

  describe "default_language is respected" do
    test "the struct's default_language is en-GB" do
      struct = %Struct{}

      assert {
               :ok,
               %Struct{
                 request: %{
                   language: "en-GB"
                 }
               }
             } = Language.call([], struct)
    end

    test "uses default_language specified in struct.private" do
      struct = %Struct{
        private: %Struct.Private{
          default_language: "cy"
        }
      }

      assert {
               :ok,
               %Struct{
                 request: %{
                   language: "cy"
                 }
               }
             } = Language.call([], struct)
    end
  end

  describe "language_from_cookie is respected" do
    test "struct.private.default_language is used when language_from_cookie is not present" do
      struct = %Struct{
        private: %Struct.Private{
          language_from_cookie: false
        }
      }

      assert {
               :ok,
               %Struct{
                 request: %{
                   language: "en-GB"
                 }
               }
             } = Language.call([], struct)
    end

    test "language_from_cookie and cookie_ckps_language of 'cy' gives language header of 'cy'" do
      struct = %Struct{
        private: %Struct.Private{
          language_from_cookie: true
        },
        request: %Struct.Request{
          cookie_ckps_language: "cy"
        }
      }

      assert {
               :ok,
               %Struct{
                 request: %{
                   language: "cy"
                 }
               }
             } = Language.call([], struct)
    end

    test "language_from_cookie and cookie_ckps_language of 'ga' gives language header of 'ga'" do
      struct = %Struct{
        private: %Struct.Private{
          language_from_cookie: true
        },
        request: %Struct.Request{
          cookie_ckps_language: "ga"
        }
      }

      assert {
               :ok,
               %Struct{
                 request: %{
                   language: "ga"
                 }
               }
             } = Language.call([], struct)
    end

    test "language_from_cookie and cookie_ckps_language of 'gd' gives language header of 'gd'" do
      struct = %Struct{
        private: %Struct.Private{
          language_from_cookie: true
        },
        request: %Struct.Request{
          cookie_ckps_language: "gd"
        }
      }

      assert {
               :ok,
               %Struct{
                 request: %{
                   language: "gd"
                 }
               }
             } = Language.call([], struct)
    end

    test "language_from_cookie and cookie_ckps_language of 'en' gives language header of 'en-GB'" do
      struct = %Struct{
        private: %Struct.Private{
          language_from_cookie: true
        },
        request: %Struct.Request{
          cookie_ckps_language: "en"
        }
      }

      assert {
               :ok,
               %Struct{
                 request: %{
                   language: "en-GB"
                 }
               }
             } = Language.call([], struct)
    end

    test "language_from_cookie and any other value of cookie_ckps_language gives language header of 'en-GB'" do
      struct = %Struct{
        private: %Struct.Private{
          language_from_cookie: true
        },
        request: %Struct.Request{
          cookie_ckps_language: "invalid"
        }
      }

      assert {
               :ok,
               %Struct{
                 request: %{
                   language: "en-GB"
                 }
               }
             } = Language.call([], struct)
    end

    test "language_from_cookie and no cookie_ckps_language gives language header of 'en-GB'" do
      struct = %Struct{
        private: %Struct.Private{
          language_from_cookie: true
        }
      }

      assert {
               :ok,
               %Struct{
                 request: %{
                   language: "en-GB"
                 }
               }
             } = Language.call([], struct)
    end
  end
end
