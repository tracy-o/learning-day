defmodule Belfrage.Pipeline do
  require Logger
  alias Belfrage.Envelope
  alias Belfrage.Behaviours.Transformer

  @spec process(Envelope.t(), Transformer.transformer_type(), [String.t()]) ::
          {:ok, Envelope.t()} | {:error, Envelope.t(), String.t()}
  def process(envelope, type, [first | rest]) do
    case Transformer.call(envelope, type, first) do
      {:ok, envelope} ->
        process(envelope, type, rest)

      {:ok, envelope, upd_transformers} ->
        process(envelope, type, update_pipeline(rest, upd_transformers))

      {:stop, envelope} ->
        {:ok, envelope}

      {:error, envelope, msg} ->
        handle_server_error(envelope, msg)

      _other ->
        handle_error(envelope)
    end
  end

  def process(envelope, _, []), do: {:ok, envelope}

  defp update_pipeline(_current, {:replace, transformers}), do: transformers
  defp update_pipeline(current, {:add, transformers}), do: transformers ++ current

  defp handle_server_error(envelope, msg) do
    :telemetry.execute([:belfrage, :error, :pipeline, :process], %{})

    Logger.log(:error, "", %{
      msg: "Transformer returned an early error",
      envelope: Envelope.loggable(envelope)
    })

    {:error, envelope, msg}
  end

  defp handle_error(envelope) do
    :telemetry.execute([:belfrage, :error, :pipeline, :process, :unhandled], %{})

    Logger.log(:error, "", %{
      msg: "Transformer did not return a valid response tuple",
      envelope: Envelope.loggable(envelope)
    })

    {:error, envelope, "Transformer did not return a valid response tuple"}
  end
end
