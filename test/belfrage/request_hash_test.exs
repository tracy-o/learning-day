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
               "fe074dec5f43c9d2babdf970ff031fd5"

      post_struct = Belfrage.Struct.add(@struct, :request, %{method: "POST"})

      assert "9db381a125afa360a6f6cc17d629c00e" ==
               RequestHash.generate(post_struct).request.request_hash
    end

    test "varies on query_params" do
      query_string_struct =
        Belfrage.Struct.add(@struct, :request, %{query_params: %{"foo" => "bar"}})

      assert RequestHash.generate(@struct).request.request_hash !=
               RequestHash.generate(query_string_struct).request.request_hash
    end

    test "when given a valid path and country" do
      assert RequestHash.generate(@struct).request.request_hash ==
               "fe074dec5f43c9d2babdf970ff031fd5"
    end

    test "varies for replayed traffic" do
      assert RequestHash.generate(@struct).request.request_hash ==
               "fe074dec5f43c9d2babdf970ff031fd5"

      replayed_struct = Belfrage.Struct.add(@struct, :request, %{has_been_replayed?: true})

      assert RequestHash.generate(replayed_struct).request.request_hash ==
               "d655ba205f3b08a77f3ff56b80b752c8"
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
