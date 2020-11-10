defmodule Belfrage.Helpers.Debug do
  @moduledoc """
  Helper functions to help identifying process bottleneck quickly.

  ### Usage

  ```
  iex> import Belfrage.Helpers.Debug
  iex> top_pid()
  #PID<0.10.0>
  ```
  """

  ######## ExMetrics worker info, pid and queue length

  def exmetrics_info(), do: Process.whereis(ExMetrics.Statsd.Worker) |> Process.info()
  def exmetrics_pid(), do: Process.whereis(ExMetrics.Statsd.Worker)

  def exmetrics_queue_len() do
    Process.whereis(ExMetrics.Statsd.Worker) |> Process.info() |> Keyword.get(:message_queue_len)
  end

  ######## return info / pids of processes that have the most reductions

  def top_info(), do: find_proc_info(:reductions)
  def top_info(num_of_processes), do: find_proc_info(:reductions, num_of_processes)

  def top_pid(), do: find_proc_pid(:reductions) |> hd
  def top_pid(num_of_processes), do: find_proc_pid(:reductions, num_of_processes)

  # def busiest_port() do
  # def busiest_port() do

  ######## return info / pids of processes that have the longest message queue

  def top_queue_info(), do: find_proc_info(:message_queue_len)
  def top_queue_info(num_of_processes), do: find_proc_info(:message_queue_len, num_of_processes)

  def top_queue_pid(), do: find_proc_pid(:message_queue_len) |> hd
  def top_queue_pid(num_of_processes), do: find_proc_pid(:message_queue_len, num_of_processes)

  ######## return info / pids of processes that use the most memory

  def top_mem_info(), do: find_proc_info(:total_heap_size)
  def top_mem_info(num_of_processes), do: find_proc_info(:heap_size, num_of_processes)

  def top_mem_pid(), do: find_proc_pid(:total_heap_size) |> hd
  def top_mem_pid(num_of_processes), do: find_proc_pid(:heap_size, num_of_processes)

  ######## find proc info / pids by keywords

  def find_proc_info(type, num_of_processes \\ 1) do
    Process.list()
    |> Enum.map(&Process.info(&1))
    |> Enum.filter(&(&1 != nil))
    |> Enum.sort(&(Keyword.get(&1, type) > Keyword.get(&2, type)))
    |> Enum.take(num_of_processes)
  end

  def find_proc_pid(type, num_of_processes \\ 1) do
    Process.list()
    |> Enum.map(&{&1, Process.info(&1)})
    |> Enum.filter(&(elem(&1, 1) != nil))
    |> Enum.sort(&(Keyword.get(elem(&1, 1), type) > Keyword.get(elem(&2, 1), type)))
    |> Enum.take(num_of_processes)
    |> Enum.map(&elem(&1, 0))
  end
end
