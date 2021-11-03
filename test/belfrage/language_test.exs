defmodule Belfrage.LanguageTest do
  use ExUnit.Case

  alias Belfrage.Struct
  alias Belfrage.Struct.Private
  alias Belfrage.Language

  describe "vary_on_language_cookie/1" do
    test "when language_from_cookie is true in the spec ckps_language is added to signature keys" do
      struct = %Struct{
        private: %Private{
          language_from_cookie: true
        }
      }

      assert %Struct{
               private: %Private{
                 signature_keys: %{skip: [], add: [:cookie_ckps_language]}
               }
             } = Language.vary_on_language_cookie(struct)
    end

    test "when language_from_cookie is false in the spec ckps_language is not added to cookie_allowlist" do
      struct = %Struct{
        private: %Private{
          language_from_cookie: false
        }
      }

      assert %Struct{
               private: %Private{
                 signature_keys: %{skip: [], add: []}
               }
             } = Language.vary_on_language_cookie(struct)
    end
  end
end
