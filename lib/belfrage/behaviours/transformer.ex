defmodule Belfrage.Behaviours.Transformer do
  alias Belfrage.Envelope

  @type updated_transformers :: {:add | :replace, list()}
  @type transformer_type :: :request | :response | :preflight

  @callback call(Envelope.t()) ::
              {:ok, Envelope.t()}
              | {:ok, Envelope.t(), updated_transformers()}
              | {:stop, Envelope.t()}
              | {:error, Envelope.t(), String.t()}

  defmacro __using__(_opts) do
    quote do
      alias Belfrage.Envelope
      alias Belfrage.Behaviours.Transformer
      @behaviour Belfrage.Behaviours.Transformer
    end
  end

  @spec call(Envelope.t(), transformer_type(), String.t()) ::
          {:ok, Envelope.t()}
          | {:ok, Envelope.t(), updated_transformers()}
          | {:stop, Envelope.t()}
          | {:error, Envelope.t(), String.t()}
  def call(envelope, type, name) do
    envelope = update_pipeline_trail(envelope, type, name)
    callback = get_transformer_callback(type, name)
    apply(callback, :call, [envelope])
  end

  @spec get_transformer_callback(transformer_type(), String.t()) :: atom()
  def get_transformer_callback(type, name) do
    Module.concat([Belfrage, get_transformer_path(type), name])
  end

  defp get_transformer_path(:request), do: RequestTransformers
  defp get_transformer_path(:response), do: ResponseTransformers
  defp get_transformer_path(:preflight), do: PreflightTransformers

  defp update_pipeline_trail(envelope, :request, name) do
    update_in(envelope.debug.request_pipeline_trail, &[name | &1])
  end

  defp update_pipeline_trail(envelope, :response, name) do
    update_in(envelope.debug.response_pipeline_trail, &[name | &1])
  end

  defp update_pipeline_trail(envelope, :preflight, name) do
    update_in(envelope.debug.preflight_pipeline_trail, &[name | &1])
  end
end
