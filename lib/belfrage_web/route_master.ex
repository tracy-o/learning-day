defmodule BelfrageWeb.RouteMaster do
  alias BelfrageWeb.{View, StructAdapter}

  @belfrage Application.get_env(:belfrage, :belfrage, Belfrage)

  defmacro __using__(_opts) do
    quote do
      use Plug.Router
      plug(:match)
      plug(:dispatch)

      import BelfrageWeb.RouteMaster

      @routes []

      @before_compile BelfrageWeb.RouteMaster

      get "/private/routes" do
        send_resp(var!(conn), 200, "Routes: #{run()}")
      end
    end
  end

  def yield(id, conn) do
    conn
    |> StructAdapter.adapt(id)
    |> @belfrage.handle()
    |> IO.inspect()
    |> View.render(conn)
  end

  defmacro handle(matcher, using: id, examples: examples) do
    quote do
      @routes [{unquote(matcher), unquote(examples)} | @routes]

      get unquote(matcher) do
        yield(unquote(id), var!(conn))
      end
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def run do
        Enum.map(@routes, fn matcher ->
          IO.inspect(matcher)
        end)
      end
    end
  end
end
