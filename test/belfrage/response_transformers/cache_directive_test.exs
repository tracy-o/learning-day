defmodule Belfrage.ResponseTransformers.CacheDirectiveTest do
  alias Belfrage.ResponseTransformers.CacheDirective
  alias Belfrage.Struct
  use ExUnit.Case

  @dials_location Application.get_env(:belfrage, :dials_location)
  @json_codec Application.get_env(:belfrage, :json_codec)

  describe "&call/1" do
    setup do
      original_dials = File.read!(@dials_location)

      on_exit(fn ->
        File.write!(@dials_location, original_dials)
        Belfrage.Dials.refresh_now()
      end)

      :ok
    end

    test "Given no cache_control response header it does nothing" do
      assert CacheDirective.call(%Struct{}) == %Struct{}
    end

    test "Given a cache control with no max age, the max age stays at 0" do
      assert CacheDirective.call(%Struct{
               response: %Struct.Response{
                 headers: %{
                   "cache-control" => "private"
                 }
               }
             }).response.cache_directive.max_age == 0
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
      File.write!(@dials_location, @json_codec.encode!(%{ttl_multiplier: "double"}))
      Belfrage.Dials.refresh_now()

      assert CacheDirective.call(%Struct{
               response: %Struct.Response{
                 headers: %{
                   "cache-control" => "public, max-age=1000"
                 }
               }
             }).response.cache_directive.max_age == 2000
    end

    test "Given an odd number max age, and a multiplier, this multiplied cache directive is returned and rounded in the response" do
      File.write!(@dials_location, @json_codec.encode!(%{ttl_multiplier: "half"}))
      Belfrage.Dials.refresh_now()

      assert CacheDirective.call(%Struct{
               response: %Struct.Response{
                 headers: %{
                   "cache-control" => "public, max-age=25"
                 }
               }
             }).response.cache_directive.max_age == 13
    end

    test "Given no max age, and a multiplier, the max age stays at 0" do
      File.write!(@dials_location, @json_codec.encode!(%{ttl_multiplier: "double"}))
      Belfrage.Dials.refresh_now()

      assert CacheDirective.call(%Struct{
               response: %Struct.Response{
                 headers: %{
                   "cache-control" => "private"
                 }
               }
             }).response.cache_directive.max_age == 0
    end

    test "Given a max age, but no multiplier, the cache directive with the original max_age is returned in the response" do
      File.write!(@dials_location, @json_codec.encode!(%{something: "else"}))
      Belfrage.Dials.refresh_now()

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
