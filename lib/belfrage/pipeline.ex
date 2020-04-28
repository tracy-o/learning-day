defmodule Belfrage.Pipeline do
  alias Belfrage.Struct

  def process(struct = %Struct{private: %Struct.Private{pipeline: [first | rest]}}) do
    root_transformer = String.to_existing_atom("Elixir.Belfrage.Transformers.#{first}")
    struct = update_in(struct.debug.pipeline_trail, &[first | &1])

    case apply(root_transformer, :call, [rest, struct]) do
      {:ok, struct} -> {:ok, struct}
      {:redirect, struct} -> call_redirect(struct)
      {:error, struct, msg} -> call_500(struct, msg)
      _ -> handle_error(struct)
    end
  end

  def process(struct = %Struct{private: %Struct.Private{pipeline: []}}) do
    {:ok, struct}
  end

  defp call_500(struct, msg) do
    ExMetrics.increment("error.pipeline.process")

    Stump.log(:error, %{
      msg: "Transformer returned an early error",
      struct: Struct.loggable(struct)
    })

    {:error, struct, msg}
  end

  defp call_redirect(struct), do: {:redirect, struct}

  def handle_error(struct) do
    ExMetrics.increment("error.pipeline.process.unhandled")

    Stump.log(:error, %{
      msg: "Transformer did not return a valid response tuple",
      struct: Struct.loggable(struct)
    })

    {:error, struct, "Transformer did not return a valid response tuple"}
  end
end
