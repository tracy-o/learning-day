defmodule Belfrage.Transformers.FablDataTest do
  use ExUnit.Case

  alias Belfrage.Transformers.FablData
  alias Belfrage.Struct
  alias Belfrage.Struct.{Request, Private}

  @anchor_request_struct %Struct{
    private: %Private{origin: "http://www.bbc.co.uk"},
    request: %Request{
      scheme: :http,
      host: "www.bbc.co.uk",
      path: "/_web_core#news-item-1"
    }
  }

  describe "FablData Transformer" do
    test "it removes the page anchor from the path" do
      assert {
               :ok,
               %Belfrage.Struct{
                 request: %Request{path: "/_web_core"}
               }
             } = FablData.call([], @anchor_request_struct)
    end
  end
end
