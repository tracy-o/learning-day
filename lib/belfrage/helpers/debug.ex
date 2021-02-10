defmodule Belfrage.Helpers.Debug do
  @moduledoc """
  Helper functions to help identifying process bottleneck quickly.

  ### Usage

    iex> import Belfrage.Helpers.Debug

    iex> top_pid()
    #PID<0.10.0>

  """

  ######## ExMetrics worker info, pid and queue length

  @doc """
  Returns the process info of `ExMetrics.Statsd.Worker`.
  """
  def exmetrics_info(), do: Process.whereis(ExMetrics.Statsd.Worker) |> Process.info()

  @doc """
  Returns the pid of `ExMetrics.Statsd.Worker`.
  """
  def exmetrics_pid(), do: Process.whereis(ExMetrics.Statsd.Worker)

  @doc """
  Returns the message queue length of `ExMetrics.Statsd.Worker`.
  """
  def exmetrics_queue_len() do
    Process.whereis(ExMetrics.Statsd.Worker) |> Process.info() |> Keyword.get(:message_queue_len)
  end

  ######## return info / pids of processes that have the most reductions

  @doc """
  Returns info of processes with the most reductions.
  """
  def top_info(), do: find_top_proc_info(:reductions)
  def top_info(num_of_processes), do: find_top_proc_info(:reductions, num_of_processes)

  @doc """
  Returns pid of processes with the most reductions.
  """
  def top_pid(), do: find_top_proc_pid(:reductions) |> hd
  def top_pid(num_of_processes), do: find_top_proc_pid(:reductions, num_of_processes)

  # def busiest_port() do
  # def busiest_port() do

  ######## return info / pids of processes that have the longest message queue

  @doc """
  Returns info of processes with the longest message queue.
  """
  def top_queue_info(), do: find_top_proc_info(:message_queue_len)
  def top_queue_info(num_of_processes), do: find_top_proc_info(:message_queue_len, num_of_processes)

  @doc """
  Returns pids of processes with the longest message queue.
  """
  def top_queue_pid(), do: find_top_proc_pid(:message_queue_len) |> hd
  def top_queue_pid(num_of_processes), do: find_top_proc_pid(:message_queue_len, num_of_processes)

  ######## return info / pids of processes that use the most memory

  @doc """
  Returns info of processes using most memory.
  """
  def top_mem_info(), do: find_top_proc_info(:total_heap_size)
  def top_mem_info(num_of_processes), do: find_top_proc_info(:heap_size, num_of_processes)

  @doc """
  Returns pids of processes using most memory.
  """
  def top_mem_pid(), do: find_top_proc_pid(:total_heap_size) |> hd
  def top_mem_pid(num_of_processes), do: find_top_proc_pid(:heap_size, num_of_processes)

  @doc """
  Returns the number of processes grouped by current function.

    iex> import Belfrage.Helpers.Debug
    Belfrage.Helpers.Debug

    iex> proc_num_per_group
    %{
      {IEx.Server, :wait_eval, 3} => 1,
      {Process, :info, 1} => 1,
      {:application_master, :loop_it, 4} => 25,
      {:application_master, :main_loop, 2} => 25,
      {:code_server, :loop, 1} => 1,
      {:disk_log, :loop, 1} => 1,
      {:erl_prim_loader, :loop, 3} => 1,
      {:erts_code_purger, :wait_for_request, 0} => 1,
      {:erts_dirty_process_signal_handler, :msg_loop, 0} => 3,
      {:erts_literal_area_collector, :msg_loop, 4} => 1,
      {:file_io_server, :server_loop, 1} => 2,
      {:gen, :do_call, 4} => 1,
      {:gen_event, :fetch_msg, 6} => 2,
      {:gen_server, :loop, 7} => 1176,
      {:gen_statem, :loop_receive, 3} => 2,
      {:global, :loop_the_locker, 1} => 1,
      {:global, :loop_the_registrar, 0} => 1,
      {:group, :server_loop, 3} => 2,
      {:gun, :loop, 1} => 1,
      {:inet_gethost_native, :main_loop, 1} => 1,
      {:init, :loop, 1} => 1,
      {:logger_std_h, :file_ctrl_loop, 1} => 1,
      {:prim_file, :helper_loop, 0} => 1,
      {:prim_inet, :accept0, 3} => 100,
      {:ranch_conns_sup, :loop, 4} => 1,
      {:socket_registry, :loop, 1} => 1,
      {:standard_error, :server_loop, 1} => 1,
      {:user_drv, :server_loop, 6} => 1
    }
  """
  def proc_num_per_group() do
    Process.list()
    |> Stream.map(&Process.info(&1))
    |> Stream.filter(&(&1 != nil))
    |> Enum.group_by(&Keyword.get(&1, :current_function))
    |> Map.new(fn {k, v} -> {k, length(v)} end)
  end

  @doc """
  Find info of processes via a keyword in current function.

    iex> import Belfrage.Helpers.Debug
    Belfrage.Helpers.Debug

    iex> find_proc_by_keyword(:gen_statem)
    [
      [
        current_function: {:gen_statem, :loop_receive, 3},
        initial_call: {:proc_lib, :init_p, 5},
        status: :waiting,
        message_queue_len: 0,
        links: [#PID<0.1570.0>],
        dictionary: [
          "$initial_call": {:tls_sender, :init, 1},
          "$ancestors": [#PID<0.1568.0>, :gun_sup, #PID<0.358.0>]
        ],
        trap_exit: false,
        error_handler: :error_handler,
        priority: :normal,
        group_leader: #PID<0.357.0>,
        total_heap_size: 1222,
        heap_size: 610,
        stack_size: 10,
        reductions: 96649,
        garbage_collection: [
          max_heap_size: %{error_logger: true, kill: true, size: 0},
          min_bin_vheap_size: 46422,
          min_heap_size: 233,
          fullsweep_after: 65535,
          minor_gcs: 98
        ],
        suspending: []
      ]
    ]
  """
  def find_proc_by_keyword(keyword, num_of_processes \\ 1) do
    Process.list()
    |> Stream.map(&Process.info(&1))
    |> Stream.filter(&(&1 != nil and Enum.member?(Tuple.to_list(Keyword.get(&1, :current_function)), keyword)))
    |> Enum.take(num_of_processes)
  end

  ######## find top proc info / pids by keywords

  def find_top_proc_info(type, num_of_processes \\ 1) do
    Process.list()
    |> Stream.map(&Process.info(&1))
    |> Stream.filter(&(&1 != nil))
    |> Enum.sort(&(Keyword.get(&1, type) > Keyword.get(&2, type)))
    |> Enum.take(num_of_processes)
  end

  def find_top_proc_pid(type, num_of_processes \\ 1) do
    Process.list()
    |> Stream.map(&{&1, Process.info(&1)})
    |> Stream.filter(&(elem(&1, 1) != nil))
    |> Enum.sort(&(Keyword.get(elem(&1, 1), type) > Keyword.get(elem(&2, 1), type)))
    |> Enum.take(num_of_processes)
    |> Enum.map(&elem(&1, 0))
  end
end
