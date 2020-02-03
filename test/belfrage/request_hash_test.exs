defmodule Belfrage.RequestHashTest do
  use ExUnit.Case

  alias Belfrage.RequestHash
  alias Belfrage.Struct

  @struct %Struct{
    request: %Struct.Request{
      scheme: :https,
      path: "/news/clips/abc123",
      country: "gb",
      method: "GET",
      has_been_replayed?: false
    }
  }

  @struct_with_different_country %Struct{
    request: %Struct.Request{
      path: "/news/clips/abc123",
      country: "usa",
      method: "GET"
    }
  }
  @struct_with_different_path %Struct{
    request: %Struct.Request{
      path: "/sport/football/abc123",
      country: "gb",
      method: "GET"
    }
  }

  @struct_for_cache_bust_request %Struct{
    private: %Struct.Private{
      overrides: %{
        "belfrage-cache-bust" => nil
      }
    }
  }

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

    test "builds repeatable request hash" do
      %Struct{request: %Struct.Request{request_hash: hash_one}} = RequestHash.generate(@struct)
      %Struct{request: %Struct.Request{request_hash: hash_two}} = RequestHash.generate(@struct)

      refute String.starts_with?(hash_one, "cache-bust.")
      refute String.starts_with?(hash_two, "cache-bust.")

      assert hash_one == hash_two
    end

    test "when the request hash is used to cache bust requests should be unique" do
      %Struct{request: %Struct.Request{request_hash: hash_one}} = RequestHash.generate(@struct_for_cache_bust_request)
      %Struct{request: %Struct.Request{request_hash: hash_two}} = RequestHash.generate(@struct_for_cache_bust_request)

      assert String.starts_with?(hash_one, "cache-bust.")
      assert String.starts_with?(hash_two, "cache-bust.")

      refute hash_one == hash_two
    end

    test "varies on scheme" do
      https_struct = @struct
      http_struct = @struct |> Belfrage.Struct.add(:request, %{scheme: :http})

      %Struct{request: %Struct.Request{request_hash: hash_one}} = RequestHash.generate(https_struct)
      %Struct{request: %Struct.Request{request_hash: hash_two}} = RequestHash.generate(http_struct)

      refute hash_one == hash_two
    end
  end
end
