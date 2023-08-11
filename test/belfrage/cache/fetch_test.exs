defmodule Belfrage.Cache.FetchTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.Cache.Fetch
  alias Belfrage.Envelope
  alias Belfrage.Envelope.Request
  alias Belfrage.Envelope.Response

  import Belfrage.Test.CachingHelper

  describe "fetch/2" do
    setup do
      envelope = %Envelope{
        request: %Request{request_hash: unique_cache_key(), path: "/news/live"}
      }

      response = %Response{body: "Cached response", personalised_route: true}
      response = put_into_cache(%Envelope{envelope | response: response})
      %{envelope: envelope, cached_response: response}
    end

    test "returns a envelope with expected values when fetching a fresh response from the local cache", %{
      envelope: envelope,
      cached_response: cached_response
    } do
      envelope = Envelope.add(envelope, :private, %{personalised_route: true, personalised_request: false})
      %Envelope{response: response, private: private} = Fetch.fetch(envelope, [:fresh])

      assert response.body == cached_response.body
      assert private.origin == :belfrage_cache
      assert private.personalised_route == true
      assert private.personalised_request == false
      assert response.fallback == false
      assert response.cache_type == nil
    end

    test "returns a envelope with expected values when fetching a fresh response from the local cache and fallback opt. is true",
         %{
           envelope: envelope,
           cached_response: cached_response
         } do
      %Envelope{response: response, private: private} = Fetch.fetch(envelope, [:fresh], fallback: true)

      assert response.body == cached_response.body
      assert private.origin == :belfrage_cache
      assert response.fallback == true
      assert response.cache_type == nil
    end

    test "returns a envelope with expected values when fetching a stale response from the local cache", %{
      envelope: envelope
    } do
      cached_response = make_cached_response_stale(envelope.request.request_hash)

      %Envelope{response: response, private: private} = Fetch.fetch(envelope, [:stale])

      assert response.body == cached_response.body
      assert private.origin == nil
      assert response.fallback == true
      assert response.cache_type == :local
    end

    test "returns a envelope with expected values when fetching a stale response from the distributed cache", %{
      envelope: envelope,
      cached_response: cached_response
    } do
      clear_cache()

      expect(Belfrage.Clients.CCPMock, :fetch, fn _envelope ->
        {:ok, cached_response}
      end)

      %Envelope{response: response, private: private} = Fetch.fetch(envelope, [:stale])

      assert response.body == cached_response.body
      assert private.origin == nil
      assert response.fallback == true
      assert response.cache_type == :distributed
    end
  end
end
