defmodule Ingress.Pipeline do
  def process(struct = %{private: %{req_pipeline: [first | rest]}}) do
    root_transformer = String.to_existing_atom("Elixir.Ingress.Pipeline.Transformers.#{first}")
    struct = put_in(struct,[:private, :transformers_tail], [first])

    case apply(root_transformer, :call, [rest, struct]) do
      {:ok, struct}            -> call_service(struct)
      {:redirect, struct, msg} -> call_redirect(struct, msg)
      {:error, struct, msg}    -> call_500(struct, msg)
    end
  end

  defp call_service(struct) do
    IO.puts("service called")
    struct
  end

  defp call_500(struct, msg) do
    IO.puts("error called")
    IO.puts(msg)
    struct
  end

  defp call_redirect(struct, msg) do
    IO.puts("redirect called")
    IO.puts(msg)
    struct
  end
end
