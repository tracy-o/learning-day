defmodule Belfrage.Transformers.EnLangOnDotComTest do
  use ExUnit.Case
  alias Belfrage.Transformers.EnLangOnDotCom

  test "when on .com tld the language is en" do
    rest = []

    struct = %Belfrage.Struct{
      request: %Belfrage.Struct.Request{
        host: "bbc.com"
      }
    }

    assert {:ok,
            %Belfrage.Struct{
              request: %Belfrage.Struct.Request{
                language: "en"
              }
            }} = EnLangOnDotCom.call(rest, struct)
  end

  test "when not on .com tld the language is not set" do
    rest = []

    struct = %Belfrage.Struct{
      request: %Belfrage.Struct.Request{
        host: "bbc.co.uk"
      }
    }

    assert {:ok,
            %Belfrage.Struct{
              request: %Belfrage.Struct.Request{
                language: nil
              }
            }} = EnLangOnDotCom.call(rest, struct)
  end
end
