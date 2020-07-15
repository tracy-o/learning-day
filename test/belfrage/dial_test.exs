defmodule Belfrage.DialTest do
  use ExUnit.Case, async: true
  use Test.Support.Helper, :mox

  alias Belfrage.Dial
  alias Belfrage.Dials.Poller
  alias Belfrage.Dials.GenericDial

  @codec Application.get_env(:belfrage, :json_codec)

  setup do
    dial_config = Fixtures.DialConfig.dial_config("a-generic-dial")

    Mox.stub(Belfrage.Helpers.FileIOMock, :read!, fn _path ->
      @codec.encode!(dial_config)
    end)

    name = String.to_atom(GenericDial.name())
    {:ok, _pid} = Belfrage.Dial.start_link(dial: GenericDial, name: name)

    %{
      dial_config: dial_config,
      dial: Enum.at(dial_config, 0)
    }
  end

  # priv/static/dials.json = cosmos/dials.json
  test "dial_config/0 returns up-to-data data", %{dial_config: dial_config} do
    assert Dial.dial_config() == dial_config
  end

  test "default/0 transforms and returns the string default state in Cosmos dials.json", %{dial: dial} do
    assert Dial.default(GenericDial) == GenericDial.transform(dial["default-value"])
  end

  test "all dial values in Cosmos dials.json are transformed", %{dial: dial} do
    for d <- dial["values"] do
      assert d["value"] |> GenericDial.transform() |> is_boolean()
    end
  end

  test "default/0 returns a boolean state" do
    assert Dial.default(GenericDial) |> is_boolean()
  end

  test "dial correctly handles changed event in which the dial boolean state is flipped" do
    dial_state = Dial.state(:"a-generic-dial")
    GenServer.cast(:"a-generic-dial", {:dials_changed, %{"a-generic-dial" => "#{!dial_state}"}})

    assert Dial.state(:"a-generic-dial") == !dial_state
  end

  describe "state/0" do
    setup do
      Poller.clear()
    end

    test "returns a default boolean state on init" do
      assert Poller.state() == %{}
      assert Dial.state(:"a-generic-dial") |> is_boolean()
    end

    test "returns a default boolean state when dials.json is malformed" do
      Belfrage.Helpers.FileIOMock
      |> expect(:read, fn _ -> {:ok, ~s(malformed json)} end)

      Poller.refresh_now()
      assert Poller.state() == %{}
      assert Dial.state(:"a-generic-dial") |> is_boolean()
    end

    test "returns a state which corresponds to the dials.json" do
      Belfrage.Helpers.FileIOMock
      |> expect(:read, fn _ -> {:ok, ~s({"a-generic-dial": "false"})} end)

      Poller.refresh_now()
      assert Poller.state() == %{"a-generic-dial" => "false"}
      assert Dial.state(:"a-generic-dial") == false
    end
  end
end
