defmodule Belfrage.Dials.SupervisorTest do
  use ExUnit.Case

  alias Belfrage.Dials

  test "dials are started with the configured default value" do
    for {module, name, default_value} <- Dials.Supervisor.dial_config() do
      assert Dials.LiveServer.state(name) == apply(module, :transform, [default_value])
    end
  end

  describe "dial_config/0" do
    test "returns dials config data in {module, atom name, default value} tuple format" do
      cosmos_dials_config = read_cosmos_dials_config()

      expected_data =
        for {name, module} <- Application.get_env(:belfrage, :dial_handlers) do
          default_value =
            cosmos_dials_config
            |> Enum.find(&(&1["name"] == name))
            |> Map.fetch!("default-value")

          {module, String.to_atom(name), default_value}
        end

      assert expected_data -- Dials.Supervisor.dial_config() == []
    end
  end

  describe "children/1" do
    test "does not include Poller in test env" do
      assert Dials.Poller in Dials.Supervisor.children([])
      refute Dials.Poller in Dials.Supervisor.children(env: :test)
    end
  end

  describe "notify/2" do
    test "updates dial value" do
      [{module, name, current_value} | _] = Dials.Supervisor.dial_config()
      different_value = get_different_dial_value(to_string(name), current_value)

      Dials.Supervisor.notify(:dials_changed, %{to_string(name) => different_value})
      assert Dials.LiveServer.state(name) == apply(module, :transform, [different_value])

      # Change the value back to what it was
      Dials.Supervisor.notify(:dials_changed, %{to_string(name) => current_value})
      assert Dials.LiveServer.state(name) == apply(module, :transform, [current_value])
    end
  end

  defp read_cosmos_dials_config() do
    "cosmos/dials.json"
    |> File.read!()
    |> Jason.decode!()
  end

  def get_different_dial_value(dial, current_value) do
    read_cosmos_dials_config()
    |> Enum.find(&(&1["name"] == dial))
    |> Map.fetch!("values")
    |> Enum.find(&(&1["value"] != current_value))
    |> Map.fetch!("value")
  end
end
