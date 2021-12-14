defmodule BelfrageWeb.RouteMaster do
  alias Plug.Conn
  alias BelfrageWeb.{View, StructAdapter}
  import BelfrageWeb.Rewriter, only: [rewrite: 1]

  defmacro __using__(_opts) do
    quote do
      use Plug.Router
      plug(BelfrageWeb.Plugs.FormatRewriter)
      plug(:match)
      plug(:dispatch)

      import BelfrageWeb.RouteMaster

      unquote(defs())

      @routes []
      @redirects []

      @before_compile BelfrageWeb.RouteMaster
    end
  end

  def yield(id, conn) do
    conn = Conn.assign(conn, :route_spec, id)

    try do
      conn
      |> StructAdapter.adapt(id)
      |> Belfrage.handle()
      |> View.render(conn)
    catch
      kind, reason ->
        # Wrap the error in `Plug.Conn.WrapperError` to preserve the `conn`
        # which now contains the name of the route spec, so that we could link
        # errors to route specs in our metrics.
        stack = __STACKTRACE__
        wrapper = %Conn.WrapperError{conn: conn, kind: :error, reason: reason, stack: stack}
        :erlang.raise(kind, wrapper, stack)
    end
  end

  defmacro handle(matcher, [using: id, examples: _examples] = args, do: block) do
    quote bind_quoted: [id: id, matcher: matcher, args: args, block: Macro.escape(block, unquote: false)] do
      var!(add_route_with_block, BelfrageWeb.RouteMaster).(matcher, id, args, block)
    end
  end

  defmacro handle(matcher, [using: id, only_on: env, examples: _examples] = args) do
    quote do
      var!(add_route_for_env, BelfrageWeb.RouteMaster).(unquote(matcher), unquote(id), unquote(args), unquote(env))
    end
  end

  defmacro handle(matcher, [using: id, only_on: env, examples: _examples] = args, do: block) do
    quote bind_quoted: [id: id, matcher: matcher, args: args, env: env, block: Macro.escape(block, unquote: false)] do
      var!(add_route_for_env_with_block, BelfrageWeb.RouteMaster).(matcher, id, args, env, block)
    end
  end

  defmacro handle_proxy_pass(matcher, [using: id, only_on: env, examples: _examples] = args) do
    quote do
      var!(add_route_for_env_proxy_pass, BelfrageWeb.RouteMaster).(
        unquote(matcher),
        unquote(id),
        unquote(args),
        unquote(env)
      )
    end
  end

  defmacro handle(matcher, [using: id, examples: _examples] = args) do
    quote do
      var!(add_route, BelfrageWeb.RouteMaster).(unquote(matcher), unquote(id), unquote(args))
    end
  end

  defmacro return_404(if: checks) when is_list(checks) do
    quote do
      if Enum.any?(unquote(checks), fn check -> check end) do
        return_404()
      end
    end
  end

  # TODO: this is just an example, and could be replaced/expanded
  # in a validator library.
  defmacro return_404(if: check_pass) do
    quote do
      if unquote(check_pass) do
        return_404()
      end
    end
  end

  defmacro return_404() do
    quote do
      View.not_found(var!(conn))
    end
  end

  defmacro no_match() do
    quote do
      catch_all_get_exists =
        Enum.find(@routes, fn {matcher, args} ->
          matcher == "/*any" and args[:only_on] == @production_environment
        end)

      unless catch_all_get_exists do
        get _ do
          return_404()
        end
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
      var!(add_redirect, BelfrageWeb.RouteMaster).(unquote(from), unquote(location), unquote(status))
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

  defp defs() do
    quote unquote: false do
      var!(add_redirect, BelfrageWeb.RouteMaster) = fn from, location, status ->
        matcher = BelfrageWeb.ReWrite.prepare(location) |> Macro.escape()

        redirect_statuses = Application.get_env(:belfrage, :redirect_statuses)

        if status not in redirect_statuses do
          raise ArgumentError, message: "only #{Enum.join(redirect_statuses, ", ")} are accepted for redirects"
        end

        uri_from = URI.parse(rewrite(from))

        @redirects [{from, location, status} | @redirects]

        get(to_string(uri_from.path), host: uri_from.host) do
          new_location = BelfrageWeb.ReWrite.interpolate(unquote(matcher), var!(conn).path_params)

          StructAdapter.adapt(var!(conn), "redirect")
          |> View.redirect(var!(conn), unquote(status), new_location)
        end
      end

      var!(add_route, BelfrageWeb.RouteMaster) = fn matcher, id, args ->
        @routes [{matcher, Enum.into(args, %{})} | @routes]

        get rewrite(matcher) do
          yield(unquote(id), var!(conn))
        end
      end

      var!(add_route_for_env, BelfrageWeb.RouteMaster) = fn matcher, id, args, env ->
        if env == @production_environment do
          @routes [{matcher, Enum.into(args, %{})} | @routes]

          get rewrite(matcher) do
            yield(unquote(id), var!(conn))
          end
        end
      end

      var!(add_route_for_env_proxy_pass, BelfrageWeb.RouteMaster) = fn matcher, id, args, env ->
        if env == @production_environment do
          @routes [{matcher, Enum.into(args, %{})} | @routes]

          get rewrite(matcher) do
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

      var!(add_route_with_block, BelfrageWeb.RouteMaster) = fn matcher, id, args, block ->
        @routes [{matcher, Enum.into(args, %{})} | @routes]

        get rewrite(matcher) do
          unquote(block) || yield(unquote(id), var!(conn))
        end
      end

      var!(add_route_for_env_with_block, BelfrageWeb.RouteMaster) = fn matcher, id, args, env, block ->
        if env == @production_environment do
          @routes [{matcher, Enum.into(args, %{})} | @routes]

          get rewrite(matcher) do
            unquote(block) || yield(unquote(id), var!(conn))
          end
        end
      end
    end
  end
end
