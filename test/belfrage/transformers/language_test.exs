defmodule Belfrage.Transformers.LanguageTest do
  use ExUnit.Case

  alias Belfrage.Transformers.Language
  alias Belfrage.Struct

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

  test "when language is already set, the language is not modified" do
    struct = %Struct{
      request: %Struct.Request{
        language: "fr"
      }
    }

    assert {
             :ok,
             %Struct{
               request: %{
                 language: "fr"
               }
             }
           } = Language.call([], struct)
  end
end
