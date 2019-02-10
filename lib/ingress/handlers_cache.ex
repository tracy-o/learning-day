defmodule Ingress.HandlersCache do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def lookup(name) do
    case :ets.lookup(__MODULE__, name) do
      [{^name, origin}] -> {:ok, origin}
      [] -> :error
    end
  end

  def put(server, name, origin) do
    GenServer.call(server, {:put, name, origin})
  end

  def reset(server) do
    GenServer.call(server, :delete)
  end

  ## Server callbacks

  @impl true
  def init(_) do
    {:ok, init_table()}
  end

  @impl true
  def handle_call({:put, name, origin}, _from, table) do
    case lookup(name) do
    {:ok, ^origin} ->
        {:reply, {:ok, :existing}, table}
      {:ok, _origin} ->
        :ets.insert(table, {name, origin})
        {:reply, {:ok, :updated}, table}
      :error ->
        :ets.insert(table, {name, origin})
        {:reply, {:ok, :created}, table}
    end
  end

  @impl true
  def handle_call(:delete, _from, table) do
    :ets.delete(table)
    {:reply, :ok, init_table()}
  end

  defp init_table do
    :ets.new(__MODULE__, [:named_table, read_concurrency: true])
  end
end
