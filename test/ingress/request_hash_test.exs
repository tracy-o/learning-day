defmodule Ingress.RequestHashTest do
  use ExUnit.Case

  alias Ingress.{RequestHash, Struct}
  alias Test.Support.StructHelper

  @struct StructHelper.build(request: %{path: "/news/clips/abc123", country: "gb"})
  @struct_with_different_country StructHelper.build(
                                   request: %{path: "/news/clips/abc123", country: "usa"}
                                 )
  @struct_with_different_path StructHelper.build(
                                request: %{path: "/sport/football/abc123", country: "gb"}
                              )

  describe "Ingress.RequestHash.generate/1" do
    test "when given a valid path and country" do
      assert RequestHash.generate(@struct).request.request_hash ==
               "cd33ccc1ce3c7b99780b4d2c44c2eb49"
    end

    test "when given the same path but country is diferent" do
      assert RequestHash.generate(@struct_with_different_country).request.request_hash ==
               "06699dca1e50c34722a856e353ed0429"
    end

    test "when given a different path and the same country" do
      assert RequestHash.generate(@struct_with_different_path).request.request_hash ==
               "46f01b89cfea511fc7db007976e255a0"
    end
  end
end
