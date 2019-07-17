defmodule Belfrage.Cache.CleanerTest do
  use ExUnit.Case
  alias Belfrage.Cache

  setup do
    :ets.delete_all_objects(:cache)

    insert_seed_cache = fn [id: id, expires_in: expires_in, last_updated: last_updated] ->
      :ets.insert(
        :cache,
        {:entry, id, last_updated, expires_in,
         {%Belfrage.Struct.Response{
            body: "hello!",
            headers: %{"content-type" => "application/json"},
            http_status: 200
          }, last_updated}}
      )
    end

    insert_seed_cache.(
      id: "cache_fresh",
      expires_in: :timer.hours(6),
      last_updated: Belfrage.Timer.now_ms()
    )

    insert_seed_cache.(
      id: "2 hours old",
      expires_in: :timer.hours(6),
      last_updated: Belfrage.Timer.now_ms() - :timer.hours(2)
    )

    insert_seed_cache.(
      id: "5 hours 30 minutes old",
      expires_in: :timer.hours(6),
      last_updated: Belfrage.Timer.now_ms() - :timer.hours(5.5)
    )

    insert_seed_cache.(
      id: "expired",
      expires_in: :timer.hours(6),
      last_updated: Belfrage.Timer.now_ms() - (:timer.hours(6) + :timer.seconds(1))
    )

    :ok
  end

  describe "cache cleaning" do
    test "When the mem usage is low, it doesn't clean anything" do
      assert 0 == Cache.Cleaner.clean_cache(10)
      assert length(:ets.tab2list(:cache)) == 4
    end

    test "When the mem usage is high, it cleans cache items older than 5 hours including expired ones" do
      assert 2 == Cache.Cleaner.clean_cache(75)
      assert length(:ets.tab2list(:cache)) == 2
    end

    test "When the mem usage is dangerously high, it cleans cache items older than 1 hour" do
      assert 3 == Cache.Cleaner.clean_cache(80)
      assert length(:ets.tab2list(:cache)) == 1
    end

    test "When cleaning the cache, the fresh items are not deleted" do
      Cache.Cleaner.clean_cache(95)
      assert length(:ets.tab2list(:cache)) == 1
      assert [{:entry, "cache_fresh", _, _, _}] = :ets.lookup(:cache, "cache_fresh")
    end
  end
end
