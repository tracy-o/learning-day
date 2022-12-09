defmodule Belfrage.Utils.Current.Mock do
  use Agent
  alias Belfrage.Utils.Current.Real

  def start_link(_opts) do
    Agent.start_link(
      fn ->
        %{is_frozen: false, frozen_value: nil}
      end,
      name: __MODULE__
    )
  end

  def date_time do
    state = Agent.get(__MODULE__, fn state -> state end)

    if state[:is_frozen] do
      state[:frozen_value]
    else
      Real.date_time()
    end
  end

  def freeze do
    Real.date_time()
  end

  def freeze(day, time) do
    {:ok, dt} = DateTime.new(day, time, "Etc/UTC")

    Agent.update(__MODULE__, fn _state ->
      %{is_frozen: true, frozen_value: dt}
    end)
  end

  def unfreeze do
    Agent.update(__MODULE__, fn _state ->
      %{is_frozen: false, frozen_value: nil}
    end)
  end
end
