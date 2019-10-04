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
    test "when given a valid path and country" do
      assert is_binary(RequestHash.generate(@struct).request.request_hash)
    end

    test "varies on method" do
      post_struct = Belfrage.Struct.add(@struct, :request, %{method: "POST"})

      refute RequestHash.generate(@struct).request.request_hash ==
               RequestHash.generate(post_struct).request.request_hash
    end

    test "varies on query_params" do
      query_string_struct = Belfrage.Struct.add(@struct, :request, %{query_params: %{"foo" => "bar"}})

      refute RequestHash.generate(@struct).request.request_hash ==
               RequestHash.generate(query_string_struct).request.request_hash
    end

    test "varies for replayed traffic" do
      replayed_struct = Belfrage.Struct.add(@struct, :request, %{has_been_replayed?: true})

      refute RequestHash.generate(@struct).request.request_hash ==
               RequestHash.generate(replayed_struct).request.request_hash
    end

    test "varies for playground traffic" do
      playground_struct = Belfrage.Struct.add(@struct, :request, %{playground?: true})

      refute RequestHash.generate(@struct).request.request_hash ==
               RequestHash.generate(playground_struct).request.request_hash
    end

    test "given the path is the same, when the country is not the same assert the request_hashes are different" do
      refute RequestHash.generate(@struct).request.request_hash ==
               RequestHash.generate(@struct_with_different_country).request.request_hash
    end

    test "given the country is the same, when the path is not the same assert the request_hashes are different" do
      refute RequestHash.generate(@struct).request.request_hash ==
               RequestHash.generate(@struct_with_different_path).request.request_hash
    end

    test "varies on subdomain" do
      custom_subdomain_struct = Belfrage.Struct.add(@struct, :request, %{subdomain: "example-branch"})

      refute RequestHash.generate(@struct).request.request_hash ==
               RequestHash.generate(custom_subdomain_struct).request.request_hash
    end
  end
end
