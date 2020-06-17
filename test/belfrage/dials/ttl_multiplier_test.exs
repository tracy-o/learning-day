defmodule Belfrage.Dials.TtlMultiplierTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.Dials.TtlMultiplier
  alias Belfrage.Dials

  setup do
    Dials.clear()

    on_exit(fn ->
      Dials.clear()
      :ok
    end)

    :ok
  end

  describe "value/0" do
    test "Changing the file gives the new ttl multiplier value" do
      Belfrage.Helpers.FileIOMock
      |> expect(:read, fn _ -> {:ok, ~s({"ttl_multiplier": "long"})} end)

      Dials.refresh_now()
      assert TtlMultiplier.value() == 3
    end

    test "when the ttl_multiplier dial is `private`, the ttl multiplier returns `0`" do
      Belfrage.Helpers.FileIOMock
      |> expect(:read, fn _ -> {:ok, ~s({"ttl_multiplier": "private"})} end)

      Dials.refresh_now()
      assert TtlMultiplier.value() == 0
    end

    test "returns the default ttl value of 1" do
      Belfrage.Helpers.FileIOMock
      |> expect(:read, fn _ -> {:ok, ~s({"foo": "bar"})} end)

      Dials.refresh_now()
      assert TtlMultiplier.value() == 1
    end
  end
end
