defmodule Ingress.RequestHashTest do
  use ExUnit.Case

  alias Ingress.{RequestHash, Struct}
  alias Test.Support.StructHelper

  @struct StructHelper.build(
    request: %{path: "/news/clips/abc123", country: "gb"}
  )

  describe "Ingress.RequestHash.generate/1" do
    test "when given a valid path and country" do
      assert RequestHash.generate(@struct).request.request_hash == "cd33ccc1ce3c7b99780b4d2c44c2eb49"
    end
  end
end