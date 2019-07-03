defmodule Ingress.Clients.HTTPTest do
  alias Ingress.Clients.HTTP
  use ExUnit.Case

  describe "Ingress.Clients.HTTP.build_options/1" do
    test "combines default and passed in options if keys are unique" do
      assert HTTP.build_options(protocol: [:http1]) == [
               timeout: 1000,
               pool: false,
               protocol: [:http1]
             ]
    end

    test "overwrites default if the same option is passed" do
      assert HTTP.build_options(timeout: 6000) == [pool: false, timeout: 6000]
    end
  end
end
