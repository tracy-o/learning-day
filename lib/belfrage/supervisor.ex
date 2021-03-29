defmodule Belfrage.Supervisor do
  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def children(env: env) do
    router_options =
      case env do
        :test -> [scheme: :http, port: 7081]
        :end_to_end -> [scheme: :http, port: 7082]
        :routes_test -> [scheme: :http, port: 7083]
        :smoke_test -> [scheme: :http, port: 7084]
        :dev -> [scheme: :http, port: 7080]
        :prod -> [scheme: :https, port: 7443]
      end

    [
      BelfrageWeb.Router.child_spec(router_options)
    ] ++ http_router(env) ++ default_children(env) ++ background_children(env)
  end

  def default_children(env) do
    [
      Belfrage.LoopsRegistry,
      Belfrage.LoopsSupervisor,
      {Belfrage.NonEssentialSupervisor, env: env},
      worker(Cachex, [:cache, [limit: cachex_limit()]])
    ]
  end

  @doc """
  background_children/1

  Processes which demand work from themselves, are regarded
  as "background" processes. For example these processes might
  use `Process.send_after(self(), :refresh, 5_000)`.

  These processes will not be started with the application
  when running the tests. Instead, they will need to be started
  independently in the test setup. For example:
  `start_supervised!(Poller)`
  or
  `start_supervised!({Belfrage.Dials.Supervisor, name: :test_dials_supervisor})`
  https://hexdocs.pm/ex_unit/ExUnit.Callbacks.html#start_supervised!/2

  For more help, see the testing best practices docs
  https://github.com/bbc/belfrage/wiki/Testing-best-practices

  Belfrage.Dials.Supervisor
  - Starts `Belfrage.Dials.Poller` process
    which periodically checks the dials file for dial changes.

  Belfrage.Credentials.Refresh
  - Periodically refreshes AWS tokens.

  Belfrage.Authentication.Jwk
  - Periodically refreshes public certificates to verify
    session tokens.

  Belfrage.Authentication.Flagpole
  - Periodically checks personalisation flagpole.

  Belfrage.MailboxMonitor
  - Monitors the size of the mailbox for gen_servers and reports them
    to CloudWatch
  """
  defp background_children(:test), do: []

  defp background_children(_env) do
    [
      Belfrage.Dials.Supervisor,
      Belfrage.Authentication.Jwk,
      Belfrage.Authentication.Flagpole,
      Belfrage.MailboxMonitor
    ]
  end

  @impl true
  def init(args) do
    Supervisor.init(children(args), strategy: :one_for_one)
  end

  defp cachex_limit(conf \\ Application.get_env(:cachex, :limit))

  defp cachex_limit(size: size, policy: policy, reclaim: reclaim, options: options) do
    {:limit, size, policy, reclaim, options}
  end

  defp http_router(:prod), do: [BelfrageWeb.Router.child_spec(scheme: :http, port: 7080)]
  defp http_router(_env), do: []
end
