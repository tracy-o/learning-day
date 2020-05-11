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

    test "varies on host" do
      co_uk_host_struct = Belfrage.Struct.add(@struct, :request, %{host: "www.bbc.co.uk"})
      com_host_struct = Belfrage.Struct.add(@struct, :request, %{host: "www.bbc.com"})

      refute RequestHash.generate(co_uk_host_struct).request.request_hash ==
               RequestHash.generate(com_host_struct).request.request_hash
    end

    test "varies on is_uk" do
      is_uk_struct = @struct |> Belfrage.Struct.add(:request, %{is_uk: true})
      is_not_uk_struct = @struct |> Belfrage.Struct.add(:request, %{is_uk: false})

      refute RequestHash.generate(is_uk_struct).request.request_hash ==
               RequestHash.generate(is_not_uk_struct).request.request_hash
    end

    test "varies on cdn?" do
      struct_with_cdn = @struct |> Belfrage.Struct.add(:request, %{cdn?: true})
      struct_without_cdn = @struct |> Belfrage.Struct.add(:request, %{cdn?: false})

      refute RequestHash.generate(struct_with_cdn).request.request_hash ==
               RequestHash.generate(struct_without_cdn).request.request_hash
    end

    test "varies on language" do
      en_struct = @struct |> Belfrage.Struct.add(:request, %{language: "en"})
      fr_struct = @struct |> Belfrage.Struct.add(:request, %{language: "fr"})

      refute RequestHash.generate(en_struct).request.request_hash ==
               RequestHash.generate(fr_struct).request.request_hash
    end

    test "varies on language_chinese" do
      trad_struct = @struct |> Belfrage.Struct.add(:request, %{language_chinese: "trad"})
      simp_struct = @struct |> Belfrage.Struct.add(:request, %{language_chinese: "simp"})

      refute RequestHash.generate(trad_struct).request.request_hash ==
               RequestHash.generate(simp_struct).request.request_hash
    end

    test "varies on language_serbian" do
      cyr_struct = @struct |> Belfrage.Struct.add(:request, %{language_serbian: "cyr"})
      lat_struct = @struct |> Belfrage.Struct.add(:request, %{language_serbian: "lat"})

      refute RequestHash.generate(cyr_struct).request.request_hash ==
               RequestHash.generate(lat_struct).request.request_hash

    test "when a key is removed the request hash doesn't vary on it" do
      uk_struct = @struct |> Belfrage.Struct.add(:private, %{remove_signature_keys: [:country]})

      kr_struct =
        @struct
        |> Belfrage.Struct.add(:request, %{country: "kr"})
        |> Belfrage.Struct.add(:private, %{remove_signature_keys: [:country]})

      assert RequestHash.generate(uk_struct).request.request_hash ==
               RequestHash.generate(kr_struct).request.request_hash
    end

    test "when a key is added the request hash does vary on it" do
      hash_one =
        @struct
        |> Belfrage.Struct.add(:request, %{payload: "one"})
        |> Belfrage.Struct.add(:private, %{add_signature_keys: [:payload]})

      hash_two =
        @struct
        |> Belfrage.Struct.add(:request, %{payload: "two"})
        |> Belfrage.Struct.add(:private, %{add_signature_keys: [:payload]})

      refute RequestHash.generate(hash_one).request.request_hash ==
               RequestHash.generate(hash_two).request.request_hash
    end
  end
end
