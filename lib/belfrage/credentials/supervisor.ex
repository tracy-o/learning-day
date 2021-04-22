defmodule Belfrage.Credentials.Supervisor do
  @moduledoc """
  These processes will not be started with the application
  when running the tests. Instead, they will need to be started
  independently in the test setup. For example:
  `start_supervised!({Belfrage.Credential.Refresh, name})`
  https://hexdocs.pm/ex_unit/ExUnit.Callbacks.html#start_supervised!/1

  For more help, see the testing best practices docs
  https://github.com/bbc/belfrage/wiki/Testing-best-practices
  """

  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(args) do
    Supervisor.init(children(args), strategy: :one_for_one, max_restarts: 40)
  end

  defp children(env: :test) do
    []
  end

  defp children(_env) do
    [
      Belfrage.Credentials.Refresh
    ]
  end
end
