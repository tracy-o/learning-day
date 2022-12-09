defmodule Belfrage.NewsApps.FailoverTest do
  use ExUnit.Case

  alias Belfrage.Utils.Current
  alias Belfrage.NewsApps

  describe "body/0" do
    test "returns an hardcoded gzipped JSON response to be used by NewsApps on failover scenarios" do
      payload =
        NewsApps.Failover.body()
        |> :zlib.gunzip()
        |> Json.decode!()

      assert payload["data"]["metadata"]["name"] == "Home"
    end
  end

  describe "update/0" do
    test "refresh the hardcoded epoch times" do
      NewsApps.Failover.update()

      body_t1 =
        NewsApps.Failover.body()
        |> :zlib.gunzip()
        |> Json.decode!()

      Current.Mock.freeze(~D[2022-12-02], ~T[11:14:52.368815Z])
      NewsApps.Failover.update()

      body_t2 =
        NewsApps.Failover.body()
        |> :zlib.gunzip()
        |> Json.decode!()

      assert body_t2["data"]["metadata"]["lastUpdated"] == 1_669_978_800_000
      assert body_t1["data"]["metadata"]["lastUpdated"] != body_t2["data"]["metadata"]["lastUpdated"]

      on_exit(&Current.Mock.unfreeze/0)
    end
  end
end
