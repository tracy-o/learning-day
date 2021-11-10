defmodule Belfrage.LanguageTest do
  use ExUnit.Case, async: true

  alias Belfrage.Struct
  alias Belfrage.Struct.{Private, Request}
  alias Belfrage.Language

  defp struct_with(opts) do
    default_language = Keyword.get(opts, :default_language, "en-GB")
    language_from_cookie = Keyword.get(opts, :language_from_cookie, false)
    cookie_ckps_language = Keyword.get(opts, :cookie_ckps_language, nil)

    %Struct{
      request: %Request{
        cookie_ckps_language: cookie_ckps_language
      },
      private: %Private{
        default_language: default_language,
        language_from_cookie: language_from_cookie
      }
    }
  end

  describe "add_signature/1" do
    test "when language_from_cookie is true in the spec ckps_language is added to signature keys" do
      assert %Struct{
               private: %Private{
                 signature_keys: %{skip: [], add: [:cookie_ckps_language]}
               }
             } = struct_with(language_from_cookie: true) |> Language.add_signature()
    end

    test "when language_from_cookie is false in the spec ckps_language is not added to cookie_allowlist" do
      assert %Struct{
               private: %Private{
                 signature_keys: %{skip: [], add: []}
               }
             } = struct_with(language_from_cookie: false) |> Language.add_signature()
    end
  end

  describe "set/1" do
    test "uses default_language specified in struct.private" do
      assert struct_with(default_language: "cy") |> Language.set() == "cy"
    end

    test "struct.private.default_language is used when language_from_cookie is not present" do
      lang =
        struct_with(language_from_cookie: false, default_language: "some_lang")
        |> Language.set()

      assert lang == "some_lang"
    end

    test "language_from_cookie and cookie_ckps_language of 'cy' gives language header of 'cy'" do
      lang =
        struct_with(language_from_cookie: true, default_language: "cy")
        |> Language.set()

      assert lang == "cy"
    end

    test "language_from_cookie and cookie_ckps_language of 'ga' gives language header of 'ga'" do
      lang =
        struct_with(language_from_cookie: true, cookie_ckps_language: "ga")
        |> Language.set()

      assert lang == "ga"
    end

    test "language_from_cookie and cookie_ckps_language of 'gd' gives language header of 'gd'" do
      lang =
        struct_with(language_from_cookie: true, cookie_ckps_language: "gd")
        |> Language.set()

      assert lang == "gd"
    end

    test "language_from_cookie and cookie_ckps_language of 'en' gives language header of 'en-GB'" do
      lang =
        struct_with(language_from_cookie: true, cookie_ckps_language: "en")
        |> Language.set()

      assert lang == "en-GB"
    end

    test "language_from_cookie and any other value of cookie_ckps_language gives the default_language" do
      lang =
        struct_with(default_language: "def_lang", language_from_cookie: true, cookie_ckps_language: "invalid")
        |> Language.set()

      assert lang == "def_lang"
    end

    test "language_from_cookie and no cookie_ckps_language gives the default_language" do
      lang =
        struct_with(default_language: "def_lang", language_from_cookie: true)
        |> Language.set()

      assert lang == "def_lang"
    end
  end

  describe "vary/1" do
    test "vary on cookie-ckps_language if language_from_cookie true" do
      struct = %Struct{
        private: %Private{
          headers_allowlist: [],
          language_from_cookie: true
        }
      }

      assert Language.vary([], struct) == ["cookie-ckps_language"]
    end

    test "don't vary on cookie-ckps_language if language_from_cookie false" do
      struct = %Struct{
        private: %Private{
          headers_allowlist: [],
          language_from_cookie: false
        }
      }

      assert Language.vary([], struct) == []
    end
  end
end
