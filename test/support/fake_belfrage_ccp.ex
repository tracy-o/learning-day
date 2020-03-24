defmodule Test.Support.FakeBelfrageCcp do
  @moduledoc """
  A fake Belfrage CCP started in the test suits, which registers itself globally
  to receive messages that would be sent to the Belfrage CCP in production.
  """
  use GenServer

  def start do
    Test.Support.FakeBelfrageCcp.start_link([])
    |> case do
      {:ok, pid} ->
        :global.register_name(:belfrage_ccp, pid)

      _already_started ->
        :ok
    end
  end

  def start_link(_opts) do
    init_state = []
    GenServer.start_link(__MODULE__, init_state, name: :fake_belfrage_ccp)
  end

  def messages do
    GenServer.call({:global, :belfrage_ccp}, :messages)
  end

  def received_message?(key) do
    GenServer.call(:fake_belfrage_ccp, :messages)
    |> Enum.find(fn
      {:put, ^key, _payload} -> true
      _ -> false
    end)
    |> is_nil()
    |> Kernel.!()
  end

  def received_message?(key, payload) do
    GenServer.call(:fake_belfrage_ccp, :messages)
    |> Enum.find(fn
      {:put, ^key, ^payload} -> true
      _ -> false
    end)
    |> is_nil()
    |> Kernel.!()
  end

  @impl true
  def init(init_state) do
    {:ok, init_state}
  end

  @impl true
  def handle_call(:messages, _from, messages) do
    {:reply, messages, messages}
  end

  @impl true
  def handle_cast({:put, key, payload} = message, state) do
    {:noreply, [message | state]}
  end
end
