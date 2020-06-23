defmodule Belfrage.Dials.CircuitBreaker do
  @moduledoc false

  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end
  
  @impl GenServer
  def init(init_arg) do
    {:ok, init_arg}
  end
end
