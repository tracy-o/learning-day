defmodule Ingress.StructTest do
  use ExUnit.Case

  alias Ingress.Struct
  alias Test.Support.StructHelper

  @loop %{origin: "https://origin.bbc.com/"}
  @struct StructHelper.build(private: %{loop_id: "example_loop_id"})

  describe "Struct.Private" do
    test "merges values to the private key of the struct" do
      assert %Struct{
               private: %Struct.Private{
                 loop_id: "example_loop_id",
                 origin: "https://origin.bbc.com/"
               }
             } = Struct.Private.put_loop(@struct, @loop)
    end
  end
end
