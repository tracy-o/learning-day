defmodule Ingress.RequestHashTest do
  use ExUnit.Case

  alias Ingress.RequestHash
  alias Test.Support.StructHelper

  @struct StructHelper.build(request: %{path: "/news/clips/abc123", country: "gb", method: "GET"})

  @struct_with_different_country StructHelper.build(
                                   request: %{
                                     path: "/news/clips/abc123",
                                     country: "usa",
                                     method: "GET"
                                   }
                                 )
  @struct_with_different_path StructHelper.build(
                                request: %{
                                  path: "/sport/football/abc123",
                                  country: "gb",
                                  method: "GET"
                                }
                              )

  describe "Ingress.RequestHash.generate/1" do
    test "varies on method" do
      assert RequestHash.generate(@struct).request.request_hash ==
               "4886146b40a8572214f8acf77649b16c"

      post_struct = Ingress.Struct.add(@struct, :request, %{method: "POST"})

      assert "a195c6e7cde34e40a2fd16be9cfaccaa" ==
               RequestHash.generate(post_struct).request.request_hash
    end

    test "when given a valid path and country" do
      assert RequestHash.generate(@struct).request.request_hash ==
               "4886146b40a8572214f8acf77649b16c"
    end

    test "given the path is the same, when the country is not the same assert the request_hashes are different" do
      assert RequestHash.generate(@struct).request.request_hash !=
               RequestHash.generate(@struct_with_different_country)
    end

    test "given the country is the same, when the path is not the same assert the request_hashes are different" do
      assert RequestHash.generate(@struct).request.request_hash !=
               RequestHash.generate(@struct_with_different_path)
    end
  end
end
