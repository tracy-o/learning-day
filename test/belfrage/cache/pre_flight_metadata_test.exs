defmodule Belfrage.Cache.PreFlightMetadataTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox
  import Belfrage.Test.CachingHelper, only: [clear_pre_flight_metadata_cache: 1]
  alias Belfrage.Cache

  setup :clear_pre_flight_metadata_cache

  describe "put/3" do
    test "puts an item into the cache" do
      assert Cache.PreFlightMetadata.put("SomeCachePrefix", "/some/path", "SOME_METADATA") == {:ok, true}

      assert [{:entry, {"SomeCachePrefix", "/some/path"}, _, _, "SOME_METADATA"}] =
               :ets.tab2list(:pre_flight_metadata_cache)
    end

    test "overwrites an item in the cache with the same key" do
      assert Cache.PreFlightMetadata.put("SomeCachePrefix", "/some/path", "SOME_METADATA") == {:ok, true}
      assert Cache.PreFlightMetadata.put("SomeCachePrefix", "/some/path", "SOME_OTHER_METADATA") == {:ok, true}

      assert [{:entry, {"SomeCachePrefix", "/some/path"}, _, _, "SOME_OTHER_METADATA"}] =
               :ets.tab2list(:pre_flight_metadata_cache)
    end

    test "does not overwrite an item in the cache with a different key" do
      assert Cache.PreFlightMetadata.put("SomeCachePrefix", "/some/path", "SOME_METADATA") == {:ok, true}
      assert Cache.PreFlightMetadata.put("SomeCachePrefix", "/some/other/path", "SOME_OTHER_METADATA") == {:ok, true}

      assert [
               {:entry, {"SomeCachePrefix", "/some/path"}, _, _, "SOME_METADATA"},
               {:entry, {"SomeCachePrefix", "/some/other/path"}, _, _, "SOME_OTHER_METADATA"}
             ] = :ets.tab2list(:pre_flight_metadata_cache)
    end
  end

  describe "get/2" do
    test "retrieves an item from the cache" do
      Cache.PreFlightMetadata.put("SomeCachePrefix", "/some/path", "SOME_METADATA")
      assert Cache.PreFlightMetadata.get("SomeCachePrefix", "/some/path") == {:ok, "SOME_METADATA"}
    end

    test "does not retrieve an item from the cache if item has expired" do
      ttl = Application.get_env(:belfrage, :pre_flight_metadata_cache)[:default_ttl_ms]

      Cache.PreFlightMetadata.put("SomeCachePrefix", "/some/path", "SOME_METADATA")

      Process.sleep(ttl + 1)

      assert Cache.PreFlightMetadata.get("SomeCachePrefix", "/some/path") == {:error, :metadata_not_found}
    end

    test "does not retrieve an item from the cache if does not exist" do
      assert Cache.PreFlightMetadata.get("SomeCachePrefix", "/some/path") == {:error, :metadata_not_found}
    end
  end
end
