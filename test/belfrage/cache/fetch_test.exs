defmodule Belfrage.Cache.FetchTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.Cache.Fetch
  alias Belfrage.Struct
  alias Belfrage.Struct.Request
  alias Belfrage.Struct.Response

  import Belfrage.Test.CachingHelper

  describe "fetch/2" do
    setup do
      struct = %Struct{
        request: %Request{request_hash: unique_cache_key()}
      }

      response = %Response{body: "Cached response", personalised_route: true}
      response = put_into_cache(%Struct{struct | response: response})
      %{struct: struct, cached_response: response}
    end

    test "returns a struct with expected values when fetching a fresh response from the local cache", %{
      struct: struct,
      cached_response: cached_response
    } do
      %Struct{response: response, private: private} = Fetch.fetch(struct, [:fresh])

      assert response.body == cached_response.body
      assert private.origin == :belfrage_cache
      assert private.personalised_route == true
      assert response.fallback == false
      assert response.cache_type == nil
    end

    test "returns a struct with expected values when fetching a stale response from the local cache", %{
      struct: struct
    } do
      cached_response = make_cached_response_stale(struct.request.request_hash)

      %Struct{response: response, private: private} = Fetch.fetch(struct, [:stale])

      assert response.body == cached_response.body
      assert private.origin == nil
      assert response.fallback == true
      assert response.cache_type == :local
    end

    test "returns a struct with expected values when fetching a stale response from the distributed cache", %{
      struct: struct,
      cached_response: cached_response
    } do
      clear_cache()

      expect(Belfrage.Clients.CCPMock, :fetch, fn _struct ->
        {:ok, cached_response}
      end)

      %Struct{response: response, private: private} = Fetch.fetch(struct, [:stale])

      assert response.body == cached_response.body
      assert private.origin == nil
      assert response.fallback == true
      assert response.cache_type == :distributed
    end
  end
end
