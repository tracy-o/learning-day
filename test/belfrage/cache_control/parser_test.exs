defmodule Belfrage.CacheControl.ParserTest do
  alias Belfrage.CacheControl
  use ExUnit.Case

  describe "&parse/1" do
    test "no cache control header" do
      assert %Belfrage.CacheControl{
               cacheability: "private",
               max_age: nil,
               stale_if_error: nil,
               stale_while_revalidate: nil
             } ==
               CacheControl.Parser.parse("")
    end

    test "parse basic private cache control header" do
      assert %Belfrage.CacheControl{
               cacheability: "private",
               max_age: nil,
               stale_if_error: nil,
               stale_while_revalidate: nil
             } ==
               CacheControl.Parser.parse("private")
    end

    test "parse cache control header with max-age" do
      assert %Belfrage.CacheControl{
               cacheability: "public",
               max_age: 31_536_000,
               stale_if_error: nil,
               stale_while_revalidate: nil
             } ==
               CacheControl.Parser.parse("public, max-age=31536000")
    end

    test "only max-age" do
      assert %Belfrage.CacheControl{
               cacheability: "public",
               max_age: 31_536_000,
               stale_if_error: nil,
               stale_while_revalidate: nil
             } ==
               CacheControl.Parser.parse("max-age=31536000")
    end

    test "parse cache control header with stale-if-error" do
      assert %Belfrage.CacheControl{
               cacheability: "public",
               max_age: nil,
               stale_if_error: 500_000,
               stale_while_revalidate: nil
             } ==
               CacheControl.Parser.parse("public, stale-if-error=500000")
    end

    test "parse cache control header with max-age and stale-if-error" do
      assert %Belfrage.CacheControl{
               cacheability: "public",
               max_age: 31_536_000,
               stale_if_error: 500_000,
               stale_while_revalidate: nil
             } ==
               CacheControl.Parser.parse("public, max-age='31536000', stale-if-error=500000")
    end

    test "parse cache control header with max-age, stale-if-error and stale-while-revalidate" do
      assert %Belfrage.CacheControl{
               cacheability: "public",
               max_age: 31_536_000,
               stale_if_error: 500_000,
               stale_while_revalidate: 10
             } ==
               CacheControl.Parser.parse("public, max-age='31536000', stale-if-error=500000, stale-while-revalidate=10")
    end

    test "is case in-sensitive" do
      assert %Belfrage.CacheControl{
               cacheability: "public",
               max_age: 31_536_000,
               stale_if_error: 500_000,
               stale_while_revalidate: 10
             } ==
               CacheControl.Parser.parse("pubLic, mAx-aGe='31536000', stAle-if-errOr=500000, stale-whiLe-revaliDate=10")
    end
  end

  describe "&parse_cacheability/1" do
    test "when directive is public with 0 max age" do
      assert "public" == CacheControl.Parser.parse_cacheability(0, ["public", "max-age=0"])
    end

    test "when directive is private" do
      assert "private" == CacheControl.Parser.parse_cacheability(30, ["private", "max-age=30"])
    end

    test "when max-age & directive forms the cache control header" do
      assert "public" == CacheControl.Parser.parse_cacheability(31_536_000, ["public", "max-age=31536000"])
    end

    test "when only max-age is set in the cache control header" do
      assert "public" == CacheControl.Parser.parse_cacheability(31_536_000, ["max-age=31536000"])
    end
  end

  describe "&parse_max_age/1" do
    test "when directive is private" do
      assert nil == CacheControl.Parser.parse_max_age(["private"])
    end

    test "when directive is public" do
      assert nil == CacheControl.Parser.parse_max_age(["public"])
    end

    test "when no quotes are used" do
      assert 31_536_000 == CacheControl.Parser.parse_max_age(["public", "max-age=31536000"])
    end
  end

  describe "&parse_stale_if_error/1" do
    test "returns stale if error value" do
      assert 500_000 ==
               CacheControl.Parser.parse_stale_if_error(["public", "max-age=31536000", "stale-if-error=500000"])
    end
  end
end
