defmodule Belfrage.CacheControlParserTest do
  alias Belfrage.CacheControlParser
  use ExUnit.Case

  describe "&parse/1" do
    test "no cache control header" do
      assert %{cacheability: "private", max_age: 0, stale_if_error: 0, stale_while_revalidate: 0} ==
               CacheControlParser.parse("")
    end

    test "parse basic private cache control header" do
      assert %{cacheability: "private", max_age: 0, stale_if_error: 0, stale_while_revalidate: 0} ==
               CacheControlParser.parse("private")
    end

    test "parse cache control header with max-age" do
      assert %{cacheability: "public", max_age: 31_536_000, stale_if_error: 0, stale_while_revalidate: 0} ==
               CacheControlParser.parse("public, max-age=31536000")
    end

    test "only max-age" do
      assert %{cacheability: "public", max_age: 31_536_000, stale_if_error: 0, stale_while_revalidate: 0} ==
               CacheControlParser.parse("max-age=31536000")
    end

    test "parse cache control header with stale-if-error" do
      assert %{cacheability: "public", max_age: 0, stale_if_error: 500_000, stale_while_revalidate: 0} ==
               CacheControlParser.parse("public, stale-if-error=500000")
    end

    test "parse cache control header with max-age and stale-if-error" do
      assert %{cacheability: "public", max_age: 31_536_000, stale_if_error: 500_000, stale_while_revalidate: 0} ==
               CacheControlParser.parse("public, max-age='31536000', stale-if-error=500000")
    end

    test "parse cache control header with max-age, stale-if-error and stale-while-revalidate" do
      assert %{cacheability: "public", max_age: 31_536_000, stale_if_error: 500_000, stale_while_revalidate: 10} ==
               CacheControlParser.parse("public, max-age='31536000', stale-if-error=500000, stale-while-revalidate=10")
    end

    test "is case in-sensitive" do
      assert %{cacheability: "public", max_age: 31_536_000, stale_if_error: 500_000, stale_while_revalidate: 10} ==
               CacheControlParser.parse("pubLic, mAx-aGe='31536000', stAle-if-errOr=500000, stale-whiLe-revaliDate=10")
    end
  end

  describe "&parse_cacheability/1" do
    test "formats cacheability when cache control header is private" do
      assert "private" == CacheControlParser.parse_cacheability(30, ["private", "max-age=30"])
    end

    test "formats cacheability when max-age included in cache control header" do
      assert "public" == CacheControlParser.parse_cacheability(31_536_000, ["public", "max-age=31536000"])
    end

    test "formats cacheability when only max-age included is in cache control header" do
      assert "public" == CacheControlParser.parse_cacheability(31_536_000, ["max-age=31536000"])
    end
  end

  describe "&parse_max_age/1" do
    test "format the cache control header, when directive is private" do
      assert 0 == CacheControlParser.parse_max_age(["private"])
    end

    test "format the cache control header, when directive is public" do
      assert 0 == CacheControlParser.parse_max_age(["public"])
    end

    test "returns max age when no quotes are used" do
      assert 31_536_000 == CacheControlParser.parse_max_age(["public", "max-age=31536000"])
    end
  end

  describe "&parse_stale_if_error/1" do
    test "get state if error value" do
      assert 500_000 == CacheControlParser.parse_stale_if_error(["public", "max-age=31536000", "stale-if-error=500000"])
    end
  end
end
