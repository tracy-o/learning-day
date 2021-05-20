defmodule Belfrage.DialTest do
  use ExUnit.Case, async: false

  alias Belfrage.Dials
  alias Belfrage.{DialMock, DialWithOptionalCallbackMock}

  use Test.Support.Helper, :mox

  setup do
    Mox.stub_with(Belfrage.DialMock, Belfrage.DialStub)
    Mox.stub_with(Belfrage.DialWithOptionalCallbackMock, Belfrage.DialStub)

    default_value = "true"
    dial_name = :"a-test-dial"

    {:ok, _pid} = Belfrage.Dials.Server.start_link({DialMock, dial_name, default_value})

    :ok
  end

  test "dial correctly handles changed event in which the dial boolean state is flipped" do
    DialMock
    |> expect(:transform, fn
      "false" -> false
      "true" -> true
    end)

    dial_state = Dials.Server.state(:"a-test-dial")
    GenServer.cast(:"a-test-dial", {:dials_changed, %{"a-test-dial" => "#{!dial_state}"}})

    assert Dials.Server.state(:"a-test-dial") == !dial_state
  end

  describe "state/0" do
    test "returns transformed initial value after init" do
      assert Dials.Server.state(:"a-test-dial") == true
    end
  end

  describe ":dials_changed logic" do
    test "when no changes are submitted" do
      state = {DialMock, "a-test-dial", true}

      assert {:noreply, {DialMock, "a-test-dial", true}} ==
               Dials.Server.handle_cast({:dials_changed, %{}}, state)
    end

    test "when a change for a different dial is submitted" do
      state = {DialMock, "a-test-dial", true}

      assert {:noreply, {DialMock, "a-test-dial", true}} ==
               Dials.Server.handle_cast({:dials_changed, %{"foo" => "bar"}}, state)
    end

    test "when a valid change for the dial is submitted" do
      state = {DialMock, "a-test-dial", true}

      assert {:noreply, {DialMock, "a-test-dial", false}} ==
               Dials.Server.handle_cast({:dials_changed, %{"a-test-dial" => "false"}}, state)
    end

    test "when dial has on_change/1 callback logic, it is called" do
      DialWithOptionalCallbackMock
      |> expect(:on_change, fn false -> :ok end)

      state = {DialWithOptionalCallbackMock, "a-test-dial", true}

      assert {:noreply, {DialWithOptionalCallbackMock, "a-test-dial", false}} ==
               Dials.Server.handle_cast({:dials_changed, %{"a-test-dial" => "false"}}, state)
    end
  end
end
