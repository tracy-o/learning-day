defmodule Belfrage.Pipeline do
  alias Belfrage.Struct

  def process(struct = %Struct{private: %Struct.Private{pipeline: [first | rest]}}) do
    root_transformer = String.to_existing_atom("Elixir.Belfrage.Transformers.#{first}")
    struct = update_in(struct.debug.pipeline_trail, &[first | &1])

    case apply(root_transformer, :call, [rest, struct]) do
      {:ok, struct} -> {:ok, struct}
      {:redirect, struct} -> {:ok, struct}
      {:stop_pipeline, struct} -> {:ok, struct}
      {:error, struct, msg} -> call_500(struct, msg)
      _ -> handle_error(struct)
    end
  end

  def process(struct = %Struct{private: %Struct.Private{pipeline: []}}) do
    {:ok, struct}
  end

  defp call_500(struct, msg) do
    Belfrage.Event.record(:metric, :increment, "error.pipeline.process")

    Belfrage.Event.record(:log, :error, %{
      msg: "Transformer returned an early error",
      struct: Struct.loggable(struct)
    })

    {:error, struct, msg}
  end

  def handle_error(struct) do
    Belfrage.Event.record(:metric, :increment, "error.pipeline.process.unhandled")

    Belfrage.Event.record(:log, :error, %{
      msg: "Transformer did not return a valid response tuple",
      struct: Struct.loggable(struct)
    })

    {:error, struct, "Transformer did not return a valid response tuple"}
  end
end
