defmodule Belfrage.Transformers.FablDataTest do
  use ExUnit.Case

  alias Belfrage.Transformers.FablData
  alias Belfrage.Struct
  alias Belfrage.Struct.{Request, Private}

  @request_struct %Struct{
    private: %Private{origin: "http://www.bbc.co.uk"},
    request: %Request{
      scheme: :http,
      host: "www.bbc.co.uk",
      path: "/fd/example-module#1234567",
      path_params: %{
        "name" => "example-module"
      }
    }
  }

  describe "FablData Transformer" do
    test "it replaces /fd with /module and uses path_params to sanitise path" do
      assert {
               :ok,
               %Belfrage.Struct{
                 request: %Request{path: "/module/example-module"}
               }
             } = FablData.call([], @request_struct)
    end
  end
end
