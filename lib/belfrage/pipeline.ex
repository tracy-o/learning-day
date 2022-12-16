defmodule Belfrage.Pipeline do
  require Logger
  alias Belfrage.Struct
  alias Belfrage.Behaviours.Transformer

  @spec process(Struct.t(), Transformer.transformer_type(), [String.t()]) ::
          {:ok, Struct.t()} | {:error, Struct.t(), String.t()}
  def process(struct, type, [first | rest]) do
    case Transformer.call(struct, type, first) do
      {:ok, struct} ->
        process(struct, type, rest)

      {:ok, struct, upd_transformers} ->
        process(struct, type, update_pipeline(rest, upd_transformers))

      {:stop, struct} ->
        {:ok, struct}

      {:error, struct, msg} ->
        handle_server_error(struct, msg)

      _other ->
        handle_error(struct)
    end
  end

  def process(struct, _, []), do: {:ok, struct}

  defp update_pipeline(_current, {:replace, transformers}), do: transformers
  defp update_pipeline(current, {:add, transformers}), do: transformers ++ current

  defp handle_server_error(struct, msg) do
    :telemetry.execute([:belfrage, :error, :pipeline, :process], %{})

    Logger.log(:error, "", %{
      msg: "Transformer returned an early error",
      struct: Struct.loggable(struct)
    })

    {:error, struct, msg}
  end

  defp handle_error(struct) do
    :telemetry.execute([:belfrage, :error, :pipeline, :process, :unhandled], %{})

    Logger.log(:error, "", %{
      msg: "Transformer did not return a valid response tuple",
      struct: Struct.loggable(struct)
    })

    {:error, struct, "Transformer did not return a valid response tuple"}
  end
end
