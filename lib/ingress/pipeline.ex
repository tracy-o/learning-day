defmodule Ingress.Pipeline do
  alias Ingress.Struct

  def process(struct = %Struct{private: %Struct.Private{pipeline: [first | rest]}}) do
    root_transformer = String.to_existing_atom("Elixir.Ingress.Transformers.#{first}")
    struct = update_in(struct.debug.pipeline_trail, &[first | &1])

    case apply(root_transformer, :call, [rest, struct]) do
      {:ok, struct} -> call_service(struct)
      {:redirect, struct, msg} -> call_redirect(struct, msg)
      {:error, struct, msg} -> call_500(struct, msg)
      _ -> handle_error()
    end
  end

  defp call_service(struct) do
    # for now..
    {:ok, struct}
  end

  defp call_500(struct, msg) do
    # for now..
    {:error, struct, msg}
  end

  defp call_redirect(struct, msg) do
    IO.puts("redirect called")
    IO.puts(msg)
    struct
  end

  def handle_error() do
    IO.puts("error")
  end
end
