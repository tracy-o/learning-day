defmodule Belfrage.Behaviours.Transformer do
  alias Belfrage.Struct

  @type updated_transformers :: {:add | :replace, list()}
  @type transformer_type :: :request | :response

  @callback call(Struct.t()) ::
              {:ok, Struct.t()}
              | {:ok, Struct.t(), updated_transformers()}
              | {:stop, Struct.t()}
              | {:error, Struct.t(), String.t()}

  defmacro __using__(_opts) do
    quote do
      alias Belfrage.Struct
      alias Belfrage.Behaviours.Transformer
      @behaviour Belfrage.Behaviours.Transformer
    end
  end

  @spec call(Struct.t(), transformer_type(), [String.t()]) ::
          {:ok, Struct.t()}
          | {:ok, Struct.t(), updated_transformers()}
          | {:stop, Struct.t()}
          | {:error, Struct.t(), String.t()}
  def call(struct, type, name) do
    struct = update_pipeline_trail(struct, type, name)
    callback = get_transformer_callback(type, name)
    apply(callback, :call, [struct])
  end

  defp get_transformer_callback(type, name) do
    Module.concat([Elixir.Belfrage, get_transformer_path(type), name])
  end

  defp get_transformer_path(:request), do: RequestTransformers
  defp get_transformer_path(:response), do: ResponseTransformers

  defp update_pipeline_trail(struct, :request, name) do
    update_in(struct.debug.request_pipeline_trail, &[name | &1])
  end

  defp update_pipeline_trail(struct, :response, name) do
    update_in(struct.debug.response_pipeline_trail, &[name | &1])
  end
end
