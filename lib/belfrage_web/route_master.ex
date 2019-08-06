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
    end
  end

  def yield(id, conn) do
    conn
    |> StructAdapter.adapt(id)
    |> @belfrage.handle()
    |> View.render(conn)
  end

  defmacro handle(matcher, [using: id, examples: examples], do: block) do
    quote do
      @routes [{unquote(matcher), unquote(examples)} | @routes]

      get unquote(matcher) do
        unquote(block) || yield(unquote(id), var!(conn))
      end
    end
  end

  defmacro handle(matcher, using: id, examples: examples) do
    quote do
      @routes [{unquote(matcher), unquote(examples)} | @routes]

      # TODO: use match here...
      get unquote(matcher) do
        yield(unquote(id), var!(conn))
      end
    end
  end

  # TODO: this is just an example, and could be replaced/expanded
  # in a validator library.
  defmacro return_404(if: check_pass) do
    quote do
      if unquote(check_pass) do
        View.not_found(var!(conn))
      end
    end
  end

  # TODO: needs better handling of the host
  # something like:
  # location = to_string(var!(conn).scheme) <> "://" <> var!(conn).host <> unquote(location)
  # plus the port etc.
  defmacro redirect(path, to: location, status: status) do
    quote do
      if unquote(status) not in [301, 302] do
        raise ArgumentError, message: "only 301 and 302 are accepted for redirects"
      end

      @routes [{unquote(path), []} | @routes]

      match(unquote(path)) do
        var!(conn)
        |> resp(unquote(status), "")
        |> put_resp_header("location", unquote(location))
      end
    end
  end
end
