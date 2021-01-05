defmodule Belfrage.ResponseTransformers.CacheDirectiveTest do
  use ExUnit.Case, async: true
  use Test.Support.Helper, :mox

  alias Belfrage.ResponseTransformers.CacheDirective
  alias Belfrage.Struct

  def set_ttl_multiplier(value) do
    stub(Belfrage.Dials.ServerMock, :state, fn :ttl_multiplier ->
      Belfrage.Dials.TtlMultiplier.transform(value)
    end)
  end

  describe "&call/1" do
    setup do
      set_ttl_multiplier("default")

      :ok
    end

    test "Given no cache_control response header it does nothing" do
      assert CacheDirective.call(%Struct{}) == %Struct{}
    end

    test "Given a cache control with no max age, the max age stays unprovided" do
      assert CacheDirective.call(%Struct{
               response: %Struct.Response{
                 headers: %{
                   "cache-control" => "private"
                 }
               }
             }).response.cache_directive.max_age == nil
    end

    test "Given a max age, this cache directive is returned in the response" do
      assert CacheDirective.call(%Struct{
               response: %Struct.Response{
                 headers: %{
                   "cache-control" => "max-age=1000"
                 }
               }
             }).response.cache_directive.max_age == 1000
    end

    test "Given a max age, and a multiplier, this multiplied cache directive is returned in the response" do
      set_ttl_multiplier("long")

      assert CacheDirective.call(%Struct{
               response: %Struct.Response{
                 headers: %{
                   "cache-control" => "public, max-age=1000"
                 }
               }
             }).response.cache_directive.max_age == 3000
    end

    test "Given a max age and a multiplier of zero, the max-age is set to 0 and the cacheability is set to private" do
      set_ttl_multiplier("private")

      assert CacheDirective.call(%Struct{
               response: %Struct.Response{
                 headers: %{
                   "cache-control" => "private, max-age=0"
                 }
               }
             }).response.cache_directive.max_age == 0
    end

    test "Given no max age, and a multiplier, the max age stays unprovided" do
      set_ttl_multiplier("long")

      assert CacheDirective.call(%Struct{
               response: %Struct.Response{
                 headers: %{
                   "cache-control" => "private"
                 }
               }
             }).response.cache_directive.max_age == nil
    end

    test "Given a max age, but no multiplier, the cache directive with the original max_age is returned in the response" do
      assert CacheDirective.call(%Struct{
               response: %Struct.Response{
                 headers: %{
                   "cache-control" => "public, max-age=1000"
                 }
               }
             }).response.cache_directive.max_age == 1000
    end
  end
end
