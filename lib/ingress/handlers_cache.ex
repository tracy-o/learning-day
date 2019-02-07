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

  ## Server callbacks

  @impl true
  def init(_) do
    table = :ets.new(__MODULE__, [:named_table, read_concurrency: true])
    {:ok, table}
  end

  @impl true
  def handle_call({:put, name, origin}, _from, table) do
    case lookup(name) do
      {:ok, _origin} ->
        {:reply, {:ok, :existing}, table}
      :error ->
        :ets.insert(table, {name, origin})
        {:reply, {:ok, :created}, table}
    end
  end
end
