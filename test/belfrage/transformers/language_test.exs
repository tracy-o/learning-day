defmodule Belfrage.Transformers.LanguageTest do
  use ExUnit.Case

  alias Belfrage.Transformers.Language
  alias Belfrage.Struct

  test "uses struct's default en-gb language" do
    struct = %Struct{}

    assert {
             :ok,
             %Struct{
               request: %{
                 language: "en-gb"
               }
             }
           } = Language.call([], struct)
  end

  test "uses default_language if it has been changed from the default" do
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
