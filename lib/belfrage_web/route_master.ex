defmodule BelfrageWeb.RouteMaster do
  defmacro __using__(_opts) do
    quote do
      use Plug.Router
      plug :match
      plug :dispatch

      import BelfrageWeb.RouteMaster

      @routes []

      @before_compile BelfrageWeb.RouteMaster

      get "/private/routes" do
        send_resp(var!(conn), 200, "Routes: #{run()}")
      end
    end
  end

  def examples(list) do
    IO.puts list
  end

  #  apply(__MODULE__, name, [])
  def using(id) do
    "Served by " <> "BelfrageRouter.Loops." <> id
  end

  defmacro handle(matcher, [using: id, examples: examples]) do
    quote do
      @routes [{unquote(matcher), unquote(examples)} | @routes]

      get unquote(matcher) do
        send_resp(var!(conn), 200, using(unquote(id)))
      end
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def run do
        Enum.map @routes, fn matcher ->
          IO.inspect matcher
        end
      end
    end
  end
end
