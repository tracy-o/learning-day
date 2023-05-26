defmodule Belfrage.Test.RoutingHelper do
  @doc """
  Defines a new platform spec with the passed name and attributes
  """
  defmacro define_platform(name, attrs) do
    quote do
      defmodule Module.concat([Routes, Platforms, unquote(name)]) do
        def specs() do
          unquote(attrs)
        end
      end
    end
  end

  @doc """
  Defines a new route spec with the passed name and attributes
  """
  defmacro define_route(name, spec_attrs, preflight_attrs) do
    quote do
      defmodule Module.concat([Routes, Specs, unquote(name)]) do
        def specs() do
          unquote(spec_attrs)
        end

        def preflight_pipeline() do
          unquote(preflight_attrs)
        end
      end
    end
  end

  defmacro define_route(name, attrs) do
    quote do
      defmodule Module.concat([Routes, Specs, unquote(name)]) do
        def specs() do
          unquote(attrs)
        end
      end
    end
  end

  defmacro define_route_with_env(name, spec_attrs, preflight_attrs) do
    quote do
      defmodule Module.concat([Routes, Specs, unquote(name)]) do
        def specs(_env) do
          unquote(spec_attrs)
        end

        def preflight_pipeline(_env) do
          unquote(preflight_attrs)
        end
      end
    end
  end

  defmacro define_request_transformer(name, envelope) do
    quote do
      defmodule Module.concat([Belfrage, RequestTransformers, unquote(name)]) do
        def call(_) do
          unquote(envelope)
        end
      end
    end
  end

  defmacro define_response_transformer(name, envelope) do
    quote do
      defmodule Module.concat([Belfrage, ResponseTransformers, unquote(name)]) do
        def call(_) do
          unquote(envelope)
        end
      end
    end
  end
end
