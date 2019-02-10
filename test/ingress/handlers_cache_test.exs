defmodule Ingress.HandlersCacheTest do
  use ExUnit.Case

  alias Ingress.HandlersCache

  setup do
    HandlersCache.reset(Ingress.HandlersCache)
  end

  test "stores handlers name and origin in ETS" do
    assert HandlersCache.put(Ingress.HandlersCache, "NewsHomepage", "https://alb") == {:ok, :created}
  end

  test "updates handlers origin in ETS" do
    assert HandlersCache.put(Ingress.HandlersCache, "NewsHomepage", "https://alb") == {:ok, :created}
    assert HandlersCache.put(Ingress.HandlersCache, "NewsHomepage", "https://fallback") == {:ok, :updated}
    assert HandlersCache.lookup("NewsHomepage") == {:ok, "https://fallback"}
  end

  test "fetch origin from cache" do
    HandlersCache.put(Ingress.HandlersCache, "NewsHomepage", "https://alb")

    assert HandlersCache.lookup("NewsHomepage") == {:ok, "https://alb"}
  end

  test "returns an error for non existing keys" do
    assert HandlersCache.lookup("Foobar") == :error
  end
end
