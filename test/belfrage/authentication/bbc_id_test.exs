defmodule Belfrage.Authentication.BBCIDTest do
  use ExUnit.Case, async: true

  alias Belfrage.Authentication.BBCID

  describe "available?/0" do
    test "returns true on startup" do
      pid = start_supervised!({BBCID, name: :bbc_id_test})
      assert BBCID.available?(pid)
    end

    test "returns false when the state is false" do
      pid = start_supervised!({BBCID, name: :bbc_id_test, available: false})
      refute BBCID.available?(pid)
    end
  end

  describe "set_availability/1" do
    test "updates availability to false" do
      pid = start_supervised!({BBCID, name: :bbc_id_test})
      assert BBCID.available?(pid)

      BBCID.set_availability(pid, false)
      refute BBCID.available?(pid)
    end

    test "updates availability to true" do
      pid = start_supervised!({BBCID, name: :bbc_id_test, available: false})
      refute BBCID.available?(pid)

      BBCID.set_availability(pid, true)
      assert BBCID.available?(pid)
    end

    test "does not accept non-boolean values" do
      pid = start_supervised!({BBCID, name: :bbc_id_test})
      assert_raise(FunctionClauseError, fn -> BBCID.set_availability(pid, :foo) end)
    end
  end
end
