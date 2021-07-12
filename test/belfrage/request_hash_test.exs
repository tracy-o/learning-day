defmodule Belfrage.RequestHashTest do
  use ExUnit.Case, async: true

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
      assert is_binary(RequestHash.generate(@struct))
    end

    test "varies on method" do
      post_struct = Belfrage.Struct.add(@struct, :request, %{method: "POST"})

      refute RequestHash.generate(@struct) == RequestHash.generate(post_struct)
    end

    test "varies on query_params" do
      query_string_struct = Belfrage.Struct.add(@struct, :request, %{query_params: %{"foo" => "bar"}})

      refute RequestHash.generate(@struct) == RequestHash.generate(query_string_struct)
    end

    test "varies for replayed traffic" do
      replayed_struct = Belfrage.Struct.add(@struct, :request, %{has_been_replayed?: true})

      refute RequestHash.generate(@struct) == RequestHash.generate(replayed_struct)
    end

    test "varies for origin simulator traffic" do
      replayed_struct = Belfrage.Struct.add(@struct, :request, %{origin_simulator?: true})

      refute RequestHash.generate(@struct) == RequestHash.generate(replayed_struct)
    end

    test "given the path is the same, when the country is not the same assert the request_hashes are different" do
      refute RequestHash.generate(@struct) == RequestHash.generate(@struct_with_different_country)
    end

    test "given the country is the same, when the path is not the same assert the request_hashes are different" do
      refute RequestHash.generate(@struct) == RequestHash.generate(@struct_with_different_path)
    end

    test "builds repeatable request hash" do
      hash_one = RequestHash.generate(@struct)
      hash_two = RequestHash.generate(@struct)

      refute String.starts_with?(hash_one, "cache-bust.")
      refute String.starts_with?(hash_two, "cache-bust.")

      assert hash_one == hash_two
    end

    test "when the request hash is used to cache bust requests should be unique" do
      hash_one = RequestHash.generate(@struct_for_cache_bust_request)
      hash_two = RequestHash.generate(@struct_for_cache_bust_request)

      assert String.starts_with?(hash_one, "cache-bust.")
      assert String.starts_with?(hash_two, "cache-bust.")

      refute hash_one == hash_two
    end

    test "varies on scheme" do
      https_struct = @struct
      http_struct = @struct |> Belfrage.Struct.add(:request, %{scheme: :http})

      refute RequestHash.generate(https_struct) == RequestHash.generate(http_struct)
    end

    test "varies on host" do
      co_uk_host_struct = Belfrage.Struct.add(@struct, :request, %{host: "www.bbc.co.uk"})
      com_host_struct = Belfrage.Struct.add(@struct, :request, %{host: "www.bbc.com"})

      refute RequestHash.generate(co_uk_host_struct) == RequestHash.generate(com_host_struct)
    end

    test "varies on is_uk" do
      is_uk_struct = @struct |> Belfrage.Struct.add(:request, %{is_uk: true})
      is_not_uk_struct = @struct |> Belfrage.Struct.add(:request, %{is_uk: false})

      refute RequestHash.generate(is_uk_struct) == RequestHash.generate(is_not_uk_struct)
    end

    test "varies on cdn?" do
      struct_with_cdn = @struct |> Belfrage.Struct.add(:request, %{cdn?: true})
      struct_without_cdn = @struct |> Belfrage.Struct.add(:request, %{cdn?: false})

      refute RequestHash.generate(struct_with_cdn) == RequestHash.generate(struct_without_cdn)
    end

    test "when a key is removed the request hash doesn't vary on it" do
      uk_struct = @struct |> Belfrage.Struct.add(:private, %{signature_keys: %{add: [], skip: [:country]}})

      kr_struct =
        @struct
        |> Belfrage.Struct.add(:request, %{country: "kr"})
        |> Belfrage.Struct.add(:private, %{signature_keys: %{add: [], skip: [:country]}})

      assert RequestHash.generate(uk_struct) == RequestHash.generate(kr_struct)
    end

    test "when a key is added the request hash does vary on it" do
      struct_one =
        @struct
        |> Belfrage.Struct.add(:request, %{payload: "one"})
        |> Belfrage.Struct.add(:private, %{signature_keys: %{add: [:payload], skip: []}})

      struct_two =
        @struct
        |> Belfrage.Struct.add(:request, %{payload: "two"})
        |> Belfrage.Struct.add(:private, %{signature_keys: %{add: [:payload], skip: []}})

      refute RequestHash.generate(struct_one) == RequestHash.generate(struct_two)
    end

    test "varies on raw_headers, when matches" do
      struct_one = @struct |> Belfrage.Struct.add(:request, %{raw_headers: %{"foo" => "boo"}})
      struct_two = struct_one

      assert RequestHash.generate(struct_one) == RequestHash.generate(struct_two)
    end

    test "varies on raw_headers, when differs" do
      struct_one = @struct |> Belfrage.Struct.add(:request, %{raw_headers: %{"foo" => "boo"}})
      struct_two = @struct |> Belfrage.Struct.add(:request, %{raw_headers: %{"foo" => "bar"}})

      refute RequestHash.generate(struct_one) == RequestHash.generate(struct_two)
    end

    test "never vary on cookie header" do
      struct_one =
        @struct |> Belfrage.Struct.add(:request, %{raw_headers: Map.merge(%{"foo" => "bar"}, %{"cookie" => "yummy"})})

      struct_two = @struct |> Belfrage.Struct.add(:request, %{raw_headers: %{"foo" => "bar"}})

      assert RequestHash.generate(struct_one) == RequestHash.generate(struct_two)
    end

    test "does not vary on personalisation headers" do
      non_personalised = @struct
      personalised = Belfrage.Struct.add(@struct, :request, %{raw_headers: %{"x-id-oidc-signedin" => "1"}})
      assert RequestHash.generate(personalised) == RequestHash.generate(non_personalised)
    end
  end

  describe "put/1" do
    test "generates and sets request_hash" do
      refute @struct.request.request_hash
      struct = RequestHash.put(@struct)
      assert struct.request.request_hash
      assert struct.request.request_hash == RequestHash.generate(@struct)
    end
  end
end
