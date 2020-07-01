defmodule Belfrage.Dials.Defaults do
  alias Belfrage.Dials.Defaults

  @codec Application.get_env(:belfrage, :json_codec)

  defmacro __using__(opts) do
    quote do
      import Defaults

      @before_compile Defaults
      @dial Keyword.get(unquote(opts), :dial)
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def default() do
        Defaults.cosmos_dials()
        |> Enum.find(&(&1["name"] == @dial))
        |> Map.get("default-value")
        |> Defaults.transform(@dial)
      end
    end
  end

  def cosmos_dials() do
    Application.app_dir(:belfrage, "priv/static/dials.json")
    |> File.read!()
    |> @codec.decode!()
  end

  # clauses that transform Cosmos string dial values to Belfrage dial states
  def transform("true", "circuit_breaker"), do: true
  def transform("false", "circuit_breaker"), do: false
end
