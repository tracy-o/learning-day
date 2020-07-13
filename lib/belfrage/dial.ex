defmodule Belfrage.Dial do
  @callback transform(any()) :: any()

  @codec Application.get_env(:belfrage, :json_codec)
  @file_io Application.get_env(:belfrage, :file_io)

  def dial_config do
    Application.app_dir(:belfrage, "priv/static/dials.json")
    |> @file_io.read!()
    |> @codec.decode!()
  end

  defmacro __using__(opts) do
    quote do
      @type state :: boolean

      use GenServer
      import Belfrage.Dial

      @dial Keyword.get(unquote(opts), :dial)

      def start_link(opts) do
        GenServer.start_link(__MODULE__, opts, name: __MODULE__)
      end

      @spec state() :: state
      def state, do: GenServer.call(__MODULE__, :state)

      def default do
        dial_config()
        |> Enum.find(&(&1["name"] == @dial))
        |> Map.get("default-value")
        |> __MODULE__.transform()
      end

      # Callbacks

      @impl GenServer
      @spec init(list) :: {:ok, state}
      def init(_opts) do
        # initial state inferred from Cosmos dials.json
        # via default() injected from Belfrage.Dials.Defaults
        # the state is to be overriden by the current dial value
        # immediately by "dials_changed" event
        {:ok, default()}
      end

      @impl GenServer
      def handle_call(:state, _from, state), do: {:reply, state, state}

      @impl GenServer
      def handle_cast({:dials_changed, %{@dial => value}}, _state), do: {:noreply, __MODULE__.transform(value)}
      def handle_cast(_, state), do: {:noreply, state}
    end
  end
end
