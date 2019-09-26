defmodule Belfrage.Clients.HTTPTest do
  alias Belfrage.Clients.HTTP
  use ExUnit.Case

  describe "Belfrage.Clients.HTTP.build_options/1" do
    test "combines default and passed in options if keys are unique" do
      assert HTTP.build_options(foo: "bar") == %{
               request_timeout: 1000,
               foo: "bar"
             }
    end

    test "overwrites default if the same option is passed" do
      assert HTTP.build_options(request_timeout: 6000) == %{request_timeout: 6000}
    end
  end
end
