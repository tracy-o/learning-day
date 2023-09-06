defmodule Belfrage.Pipeline do
  require Logger
  alias Belfrage.Envelope
  alias Belfrage.Behaviours.Transformer

  @spec process(Envelope.t(), Transformer.transformer_type(), [String.t()]) ::
          {:ok, Envelope.t()} | {:error, Envelope.t(), String.t()}
  def process(envelope, _, []), do: {:ok, envelope}

  def process(envelope, type, [first | rest]) do
    case Transformer.call(envelope, type, first) do
      {:ok, envelope} ->
        process(envelope, type, rest)

      {:ok, envelope, upd_transformers} ->
        process(envelope, type, update_pipeline(rest, upd_transformers))

      {:stop, envelope} ->
        {:ok, envelope}

      {:error, envelope, msg} ->
        handle_server_error(envelope, type, msg)
    end
  end

  defp update_pipeline(_current, {:replace, transformers}), do: transformers
  defp update_pipeline(current, {:add, transformers}), do: transformers ++ current

  defp handle_server_error(envelope, type, msg) do
    :telemetry.execute([:belfrage, :error, :pipeline, :process], %{})
    log_error(envelope, type, "Transformer returned an early error")
    {:error, envelope, msg}
  end

  defp log_error(envelope, type, msg) do
    Logger.log(:warn, "", %{
      msg: msg,
      type: type,
      envelope: Envelope.loggable(envelope)
    })
  end
end
