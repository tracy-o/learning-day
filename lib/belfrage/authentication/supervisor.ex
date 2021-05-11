defmodule Belfrage.Authentication.Supervisor do
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

  defp children(env: :routes_test) do
    []
  end

  defp children(_env) do
    [
      Belfrage.Authentication.Jwk,
      Belfrage.Authentication.Flagpole
    ]
  end
end
