defmodule Belfrage.Clients.LambdaTest do
  alias Belfrage.Clients.Lambda
  use ExUnit.Case

  describe "Belfrage.Clients.Lambda.call/3" do
    test "Given a working function name, role arn, and payload it authenticates and calls the lambda and returns the response" do
      assert Lambda.call("webcore-lambda-role-arn", "presentation-lambda", %{some: "data"}) ==
               {:ok, "<h1>A Page</h1>"}
    end

    test "Given a role we cannot assume we return the :failed_to_assume_role error" do
      assert Lambda.call("the-wrong-role", "presentation-lambda", %{some: "data"}) ==
               {:error, :credentials_not_found_in_cache}
    end

    test "Given a working role, but an incorrect function name we return the :failed_to_invoke_lambda error" do
      assert Lambda.call("webcore-lambda-role-arn", "not-a-real-lambda", %{some: "data"}) ==
               {:error, :failed_to_invoke_lambda}
    end
  end

  describe "Belfrage.Clients.Lambda.build_options/1" do
    test "combines default and passed in options if keys are unique" do
      assert Lambda.build_options(timeout: 1000) == [
               timeout: 1000,
               protocols: [:http2, :http1],
               pool: false
             ]
    end

    test "overwrites default if the same option is passed" do
      assert Lambda.build_options(protocols: [:http2], pool: true) == [
               protocols: [:http2, :http1],
               pool: false
             ]
    end
  end
end
