defmodule Belfrage.Transformers.SportPal do
  use Belfrage.Transformers.Transformer

  @impl true
  def call(rest, struct) do
    cond do
      String.match?(struct.request.path, ~r/\/pal($|[.?]+)/) ->
        struct = clean_url(struct, struct.request.path)
        then(rest, struct)

      true ->
        then(rest, struct)
    end
  end

  defp clean_url(struct, path) do
    new_path = String.replace(path, ~r/\/pal($|[.?]+)/, "")
    Struct.add(struct, :request, %{path: new_path})
  end
end
