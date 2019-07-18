defmodule Belfrage.RequestHashTest do
  use ExUnit.Case

  alias Belfrage.RequestHash
  alias Test.Support.StructHelper

  @struct StructHelper.build(
            request: %{path: "/news/clips/abc123", country: "gb", method: "GET", has_been_replayed?: false}
          )

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

  describe "Belfrage.RequestHash.generate/1" do
    test "varies on method" do
      assert RequestHash.generate(@struct).request.request_hash ==
               "55783bbe06abbcc6edd2552ad57b26d3"

      post_struct = Belfrage.Struct.add(@struct, :request, %{method: "POST"})

      assert "b931981548b0d6e9a86b6bdf90318ca6" ==
               RequestHash.generate(post_struct).request.request_hash
    end

    test "when given a valid path and country" do
      assert RequestHash.generate(@struct).request.request_hash ==
               "55783bbe06abbcc6edd2552ad57b26d3"
    end

    test "varies for replayed traffic" do
      assert RequestHash.generate(@struct).request.request_hash ==
               "55783bbe06abbcc6edd2552ad57b26d3"

      replayed_struct = Belfrage.Struct.add(@struct, :request, %{has_been_replayed?: true})

      assert RequestHash.generate(replayed_struct).request.request_hash ==
               "1e587eb1344c5d335badb8881c8693fe"
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
