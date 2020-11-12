defmodule Belfrage.Authentication.FlagpoleTest do
  use ExUnit.Case, async: true

  alias Belfrage.Authentication.Flagpole

  @flagpole_server :flagpole_test

  setup do
    {:ok, _pid} = start_supervised({Flagpole, [name: @flagpole_server]})
    :ok
  end

  test "default server state is true after startup" do
    assert true = Flagpole.state(@flagpole_server)
  end

  test "state/1 returns boolean state" do
    assert is_boolean(Flagpole.state(@flagpole_server))
  end
end
