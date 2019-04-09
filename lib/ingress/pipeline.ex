defmodule Ingress.Pipeline do
  alias Ingress.Struct

  def process(struct = %Struct{private: %Struct.Private{pipeline: [first | rest]}}) do
    root_transformer = String.to_existing_atom("Elixir.Ingress.Transformers.#{first}")
    struct = update_in(struct.debug.pipeline_trail, &[first | &1])

    case apply(root_transformer, :call, [rest, struct]) do
      {:ok, struct} -> {:ok, struct}
      {:redirect, struct} -> call_redirect(struct)
      {:error, struct, msg} -> call_500(struct, msg)
      _ -> handle_error(struct)
    end
  end

  defp call_500(struct, msg) do
    # for now..
    ExMetrics.increment("error.pipeline.process")
    {:error, struct, msg}
  end

  defp call_redirect(struct) do
    ExMetrics.increment("error.pipeline.process.redirect")
    {:ok, struct}
  end

  def handle_error(struct) do
    ExMetrics.increment("error.pipeline.process.unhandled")
    {:error, struct, "Transformer did not return a valid response tuple"}
  end
end
