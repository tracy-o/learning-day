defmodule Belfrage.ResponseTransformers.CacheDirectiveTest do
  alias Belfrage.ResponseTransformers.CacheDirective
  alias Belfrage.Struct
  use ExUnit.Case

  @dials_location Application.get_env(:belfrage, :dials_location)

  describe "&call/1" do
    setup do
      original_dials = File.read!(@dials_location)

      on_exit(fn ->
        File.write!(@dials_location, original_dials)
        Process.send(:dials, :refresh, [])
      end)

      :ok
    end

    test "Given no cache_control response header it does nothing" do
      assert CacheDirective.call(%Struct{}) == %Struct{}
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
      File.write!(@dials_location, Eljiffy.encode!(%{ttl_multiplier: "2"}))
      Process.send(:dials, :refresh, [])

      assert CacheDirective.call(%Struct{
               response: %Struct.Response{
                 headers: %{
                   "cache-control" => "public, max-age=1000"
                 }
               }
             }).response.cache_directive.max_age == 2000
    end
  end
end
