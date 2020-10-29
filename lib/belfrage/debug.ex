defmodule Belfrage.Debug do
  @moduledoc """
  Helper functions to help identifying process bottleneck quickly.

  ### Usage

  ```
  iex> alias Belfrage.Debug
  iex> Debug.busiest_pid()
  #PID<0.10.0>
  ```
  """

  def exmetrics_info(), do: Process.whereis(ExMetrics.Statsd.Worker) |> Process.info()
  def exmetrics_pid(), do: Process.whereis(ExMetrics.Statsd.Worker)

  def exmetrics_queue_len() do
    Process.whereis(ExMetrics.Statsd.Worker) |> Process.info() |> Keyword.get(:message_queue_len)
  end

  ######## return info / pids of processes that have the most reductions

  def busiest_info() do
    Process.list()
    |> Enum.map(&Process.info(&1))
    |> Enum.filter(&(&1 != nil))
    |> Enum.sort(&(Keyword.get(&1, :reductions) > Keyword.get(&2, :reductions)))
    |> List.first()
  end

  def busiest_info(num_of_processes) do
    Process.list()
    |> Enum.map(&Process.info(&1))
    |> Enum.filter(&(&1 != nil))
    |> Enum.sort(&(Keyword.get(&1, :reductions) > Keyword.get(&2, :reductions)))
    |> Enum.take(num_of_processes)
  end

  def busiest_pid() do
    Process.list()
    |> Enum.map(&{&1, Process.info(&1)})
    |> Enum.filter(&(elem(&1, 1) != nil))
    |> Enum.sort(&(Keyword.get(elem(&1, 1), :reductions) > Keyword.get(elem(&2, 1), :reductions)))
    |> List.first()
    |> elem(0)
  end

  def busiest_pid(num_of_processes) do
    Process.list()
    |> Enum.map(&{&1, Process.info(&1)})
    |> Enum.filter(&(elem(&1, 1) != nil))
    |> Enum.sort(&(Keyword.get(elem(&1, 1), :reductions) > Keyword.get(elem(&2, 1), :reductions)))
    |> Enum.take(num_of_processes)
    |> Enum.map(&elem(&1, 0))
  end

  # def busiest_port() do
  # def busiest_port() do

  ######## return info / pids of processes that have the longest message queue

  def longest_queue_info() do
    Process.list()
    |> Enum.map(&Process.info(&1))
    |> Enum.filter(&(&1 != nil))
    |> Enum.sort(&(Keyword.get(&1, :message_queue_len) > Keyword.get(&2, :message_queue_len)))
    |> List.first()
  end

  def longest_queue_info(num_of_processes) do
    Process.list()
    |> Enum.map(&Process.info(&1))
    |> Enum.filter(&(&1 != nil))
    |> Enum.sort(&(Keyword.get(&1, :message_queue_len) > Keyword.get(&2, :message_queue_len)))
    |> Enum.take(num_of_processes)
  end

  def longest_queue_pid() do
    Process.list()
    |> Enum.map(&{&1, Process.info(&1)})
    |> Enum.filter(&(elem(&1, 1) != nil))
    |> Enum.sort(&(Keyword.get(elem(&1, 1), :message_queue_len) > Keyword.get(elem(&2, 1), :message_queue_len)))
    |> List.first()
    |> elem(0)
  end

  def longest_queue_pid(num_of_processes) do
    Process.list()
    |> Enum.map(&{&1, Process.info(&1)})
    |> Enum.filter(&(elem(&1, 1) != nil))
    |> Enum.sort(&(Keyword.get(elem(&1, 1), :message_queue_len) > Keyword.get(elem(&2, 1), :message_queue_len)))
    |> Enum.take(num_of_processes)
    |> Enum.map(&elem(&1, 0))
  end

  ######## return info / pids of processes that use the most memory

  def most_mem_use_info() do
    Process.list()
    |> Enum.map(&Process.info(&1))
    |> Enum.filter(&(&1 != nil))
    |> Enum.sort(&(Keyword.get(&1, :total_heap_size) > Keyword.get(&2, :total_heap_size)))
    |> List.first()
  end

  def most_mem_use_info(num_of_processes) do
    Process.list()
    |> Enum.map(&Process.info(&1))
    |> Enum.filter(&(&1 != nil))
    |> Enum.sort(&(Keyword.get(&1, :total_heap_size) > Keyword.get(&2, :total_heap_size)))
    |> Enum.take(num_of_processes)
  end

  def most_mem_use_pid() do
    Process.list()
    |> Enum.map(&{&1, Process.info(&1)})
    |> Enum.filter(&(elem(&1, 1) != nil))
    |> Enum.sort(&(Keyword.get(elem(&1, 1), :total_heap_size) > Keyword.get(elem(&2, 1), :total_heap_size)))
    |> List.first()
    |> elem(0)
  end

  def most_mem_use_pid(num_of_processes) do
    Process.list()
    |> Enum.map(&{&1, Process.info(&1)})
    |> Enum.filter(&(elem(&1, 1) != nil))
    |> Enum.sort(&(Keyword.get(elem(&1, 1), :total_heap_size) > Keyword.get(elem(&2, 1), :total_heap_size)))
    |> Enum.take(num_of_processes)
    |> Enum.map(&elem(&1, 0))
  end
end
