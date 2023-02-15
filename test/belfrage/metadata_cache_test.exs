defmodule Belfrage.MetadataCacheTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox
  import Belfrage.Test.CachingHelper, only: [clear_metadata_cache: 1]
  alias Belfrage.MetadataCache

  setup :clear_metadata_cache

  describe "put/3" do
    test "puts an item into the cache" do
      assert MetadataCache.put("SomeSource", "/some/path", "SOME_METADATA") == {:ok, true}

      assert [{:entry, {"SomeSource", "/some/path"}, _, _, "SOME_METADATA"}] = :ets.tab2list(:metadata_cache)
    end

    test "overwrites an item in the cache with the same key" do
      assert MetadataCache.put("SomeSource", "/some/path", "SOME_METADATA") == {:ok, true}
      assert MetadataCache.put("SomeSource", "/some/path", "SOME_OTHER_METADATA") == {:ok, true}

      assert [{:entry, {"SomeSource", "/some/path"}, _, _, "SOME_OTHER_METADATA"}] = :ets.tab2list(:metadata_cache)
    end

    test "does not overwrite an item in the cache with a different key" do
      assert MetadataCache.put("SomeSource", "/some/path", "SOME_METADATA") == {:ok, true}
      assert MetadataCache.put("SomeSource", "/some/other/path", "SOME_OTHER_METADATA") == {:ok, true}

      assert [
               {:entry, {"SomeSource", "/some/path"}, _, _, "SOME_METADATA"},
               {:entry, {"SomeSource", "/some/other/path"}, _, _, "SOME_OTHER_METADATA"}
             ] = :ets.tab2list(:metadata_cache)
    end
  end

  describe "get/2" do
    test "retrieves an item from the cache" do
      MetadataCache.put("SomeSource", "/some/path", "SOME_METADATA")
      assert MetadataCache.get("SomeSource", "/some/path") == {:ok, "SOME_METADATA"}
    end

    test "does not retrieve an item from the cache if item has expired" do
      ttl = Application.get_env(:belfrage, :metadata_cache)[:default_ttl_ms]

      MetadataCache.put("SomeSource", "/some/path", "SOME_METADATA")

      Process.sleep(ttl + 1)

      assert MetadataCache.get("SomeSource", "/some/path") == {:error, :metadata_not_found}
    end

    test "does not retrieve an item from the cache if does not exist" do
      assert MetadataCache.get("SomeSource", "/some/path") == {:error, :metadata_not_found}
    end
  end
end
