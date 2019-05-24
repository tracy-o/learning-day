defmodule Ingress.Clients.LambdaTest do
  alias Ingress.Clients.Lambda
  use ExUnit.Case

  describe "Ingress.Clients.Lambda.build_options/1" do
    test "combines default and passed in options if keys are unique" do
      assert Lambda.build_options(timeout: 1000) == [
               protocols: [:http1],
               pool: false,
               timeout: 1000
             ]
    end

    test "overwrites default if the same option is passed" do
      assert Lambda.build_options(protocols: [:http2], pool: true) == [
               protocols: [:http2],
               pool: true
             ]
    end
  end
end
