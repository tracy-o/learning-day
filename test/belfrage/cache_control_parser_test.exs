defmodule Belfrage.ResponseTransformers.CacheDirectiveTest do
  alias Belfrage.CacheControlParser
  use ExUnit.Case

  describe "&parse/1" do
    test "parse basic cache control header" do
      assert %{cacheability: "private", max_age: 0, stale_if_error: 0} == CacheControlParser.parse("private")
    end

    test "parse cache control header with max-age" do
      assert %{cacheability: "public", max_age: 31_536_000, stale_if_error: 0} ==
               CacheControlParser.parse("public, max-age=31536000")
    end

    test "parse cache control header with stale-if-error" do
      assert %{cacheability: "public", max_age: 0, stale_if_error: 500_000} ==
               CacheControlParser.parse("public, stale-if-error=500000")
    end

    test "parse cache control header with max-age and stale-if-error" do
      assert %{cacheability: "public", max_age: 31_536_000, stale_if_error: 500_000} ==
               CacheControlParser.parse("public, max-age='31536000', stale-if-error=500000")
    end
  end

  describe "&parse_cacheability/1" do
    test "format the cache control header" do
      assert "private" == CacheControlParser.parse_cacheability("private")
    end

    test "returns max age when no quotes are used" do
      assert "public" == CacheControlParser.parse_cacheability("public, max-age=31536000")
    end

    test "returns max age when quotes are used" do
      assert "public" == CacheControlParser.parse_cacheability("public, max-age='31536000'")
    end
  end

  describe "&parse_max_age/1" do
    test "format the cache control header" do
      assert 0 == CacheControlParser.parse_max_age("private")
    end

    test "returns max age when no quotes are used" do
      assert 31_536_000 == CacheControlParser.parse_max_age("public, max-age=31536000")
    end

    test "returns max age when quotes are used" do
      assert 31_536_000 == CacheControlParser.parse_max_age("public, max-age='31536000'")
    end
  end

  describe "&parse_stale_if_error/1" do
    test "get state if error value" do
      assert 500_000 == CacheControlParser.parse_stale_if_error("public, max-age='31536000', stale-if-error=500000")
    end
  end
end
