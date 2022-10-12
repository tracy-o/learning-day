defmodule Belfrage.Pipeline do
  require Logger
  alias Belfrage.Struct

  def process(struct, :request, _pipeline = [first | rest]) do
    root_transformer = String.to_existing_atom("Elixir.Belfrage.Transformers.#{first}")
    struct = update_in(struct.debug.request_pipeline_trail, &[first | &1])

    begin_pipeline(struct, root_transformer, rest)
  end

  def process(struct, :response, _pipeline = [first | rest]) do
    root_transformer = String.to_existing_atom("Elixir.Belfrage.ResponseTransformers.#{first}")
    struct = update_in(struct.debug.response_pipeline_trail, &[first | &1])

    begin_pipeline(struct, root_transformer, rest)
  end

  def process(struct, _any, _pipeline = []), do: {:ok, struct}

  def begin_pipeline(struct, root_transformer, rest) do
    case apply(root_transformer, :call, [rest, struct]) do
      {:ok, struct} -> {:ok, struct}
      {:redirect, struct} -> {:ok, struct}
      {:stop_pipeline, struct} -> {:ok, struct}
      {:error, struct, msg} -> call_500(struct, msg)
      _ -> handle_error(struct)
    end
  end

  defp call_500(struct, msg) do
    :telemetry.execute([:belfrage, :error, :pipeline, :process], %{})

    Logger.log(:error, "", %{
      msg: "Transformer returned an early error",
      struct: Struct.loggable(struct)
    })

    {:error, struct, msg}
  end

  def handle_error(struct) do
    :telemetry.execute([:belfrage, :error, :pipeline, :process, :unhandled], %{})

    Logger.log(:error, "", %{
      msg: "Transformer did not return a valid response tuple",
      struct: Struct.loggable(struct)
    })

    {:error, struct, "Transformer did not return a valid response tuple"}
  end
end
