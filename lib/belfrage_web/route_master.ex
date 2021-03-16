defmodule BelfrageWeb.RouteMaster do
  alias BelfrageWeb.{View, StructAdapter}
  import BelfrageWeb.Rewriter, only: [rewrite: 1]

  @belfrage Application.get_env(:belfrage, :belfrage, Belfrage)

  defmacro __using__(_opts) do
    quote do
      use Plug.Router
      plug(BelfrageWeb.Plugs.FormatRewriter)
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

      get rewrite(unquote(matcher)) do
        unquote(block) || yield(unquote(id), var!(conn))
      end
    end
  end

  defmacro handle(matcher, [using: id, only_on: env, examples: _examples] = args) do
    quote do
      @routes [{unquote(matcher), Enum.into(unquote(args), %{})} | @routes]
      @production_environment Application.get_env(:belfrage, :production_environment)

      get rewrite(unquote(matcher)) when unquote(env) == @production_environment do
        yield(unquote(id), var!(conn))
      end
    end
  end

  defmacro handle(matcher, [using: id, only_on: env, examples: _examples] = args, do: block) do
    quote do
      @routes [{unquote(matcher), Enum.into(unquote(args), %{})} | @routes]
      @production_environment Application.get_env(:belfrage, :production_environment)

      get rewrite(unquote(matcher)) when unquote(env) == @production_environment do
        unquote(block) || yield(unquote(id), var!(conn))
      end
    end
  end

  defmacro handle_proxy_pass(matcher, [using: id, only_on: env, examples: _examples] = args) do
    quote do
      @routes [{unquote(matcher), Enum.into(unquote(args), %{})} | @routes]
      get rewrite(unquote(matcher)) do
        matched_env = var!(conn).private[:production_environment] == unquote(env)
        origin_simulator = var!(conn).private.bbc_headers.origin_simulator
        replayed_traffic = var!(conn).private.bbc_headers.replayed_traffic

        cond do
          matched_env and origin_simulator -> yield(unquote(id), var!(conn))
          matched_env and replayed_traffic -> yield(unquote(id), var!(conn))
          true -> View.not_found(var!(conn))
        end
      end
    end
  end

  defmacro handle(matcher, [using: id, examples: _examples] = args) do
    quote do
      @routes [{unquote(matcher), Enum.into(unquote(args), %{})} | @routes]

      # TODO: use match here...
      get rewrite(unquote(matcher)) do
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
    matcher = BelfrageWeb.ReWrite.prepare(location) |> Macro.escape()

    quote do
      redirect_statuses = Application.get_env(:belfrage, :redirect_statuses)

      if unquote(status) not in redirect_statuses do
        raise ArgumentError, message: "only #{Enum.join(redirect_statuses, ", ")} are accepted for redirects"
      end

      uri_from = URI.parse(unquote(from))

      @redirects [{unquote(from), unquote(location), unquote(status)} | @redirects]

      get(to_string(uri_from.path), host: uri_from.host) do
        new_location =
          BelfrageWeb.Rewriter.rewrite_without_slash_extension(
            BelfrageWeb.ReWrite.interpolate(unquote(matcher), var!(conn).path_params)
          )

        StructAdapter.adapt(var!(conn), "redirect")
        |> View.redirect(var!(conn), unquote(status), new_location)
      end
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def redirects, do: @redirects

      def routes do
        @routes
        |> Enum.flat_map(fn
          {matcher, args = %{using: using}} when is_list(using) ->
            Enum.map(using, fn loop_id ->
              args =
                args
                |> Map.put_new(:only_on, nil)
                |> Map.put(:using, loop_id)

              {matcher, args}
            end)

          {route, args} ->
            [{route, Map.put_new(args, :only_on, nil)}]
        end)
      end
    end
  end
end
