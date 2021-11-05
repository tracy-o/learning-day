defmodule Belfrage.Services.Webcore.Supervisor do
  use Supervisor

  alias Belfrage.Services.Webcore.Credentials

  def start_link(_) do
    Supervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl true
  def init(_) do
    children =
      [Credentials]
      |> add_credentials_poller()

    Supervisor.init(children, strategy: :one_for_one, max_restarts: 40)
  end

  defp add_credentials_poller(children) do
    if Application.get_env(:belfrage, :webcore_credentials_polling_enabled) do
      children ++ [Credentials.Poller]
    else
      children
    end
  end
end
