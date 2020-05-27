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
      @redirects []

      @before_compile BelfrageWeb.RouteMaster
    end
  end

  def yield(id, conn) do
    conn
    |> StructAdapter.adapt(id)
    |> @belfrage.handle()
    |> View.render(conn)
  end

  defmacro handle(matcher, [using: id, examples: _examples] = args, do: block) do
    quote do
      @routes [{unquote(matcher), Enum.into(unquote(args), %{})} | @routes]

      get unquote(matcher) do
        unquote(block) || yield(unquote(id), var!(conn))
      end
    end
  end

  defmacro handle(matcher, [using: id, only_on: env, examples: _examples] = args) do
    quote do
      @routes [{unquote(matcher), Enum.into(unquote(args), %{})} | @routes]

      # TODO: use match here...
      get unquote(matcher) do
        if var!(conn).private[:production_environment] != unquote(env) do
          View.not_found(var!(conn))
        else
          yield(unquote(id), var!(conn))
        end
      end
    end
  end

  defmacro handle(matcher, [using: id, examples: _examples] = args) do
    quote do
      @routes [{unquote(matcher), Enum.into(unquote(args), %{})} | @routes]

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

  defmacro no_match do
    quote do
      get _ do
        View.not_found(var!(conn))
      end

      match _ do
        View.unsupported_method(var!(conn))
      end
    end
  end

  # TODO: needs better handling of the host
  # something like:
  # location = to_string(var!(conn).scheme) <> "://" <> var!(conn).host <> unquote(location)
  # plus the port etc.
  defmacro redirect(from, to: location, status: status) do
    quote do
      redirect_statuses = Application.get_env(:belfrage, :redirect_statuses)

      if unquote(status) not in redirect_statuses do
        raise ArgumentError, message: "only #{Enum.join(redirect_statuses, ", ")} are accepted for redirects"
      end

      uri_from = URI.parse(unquote(from))

      @redirects [{uri_from.path, []} | @redirects]

      match(to_string(uri_from.path), host: uri_from.host) do
        new_location =
          unquote(location)
          |> String.replace("/*", to_string(var!(conn).request_path))
          |> String.trim_trailing("/")

        View.redirect(var!(conn), unquote(status), new_location)
      end
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def routes, do: @routes
    end
  end
end
