defmodule Belfrage.Transformers.FablData do
  use Belfrage.Transformers.Transformer

  @anchor_matcher ~r/#.*$/

  @impl true
  def call(rest, struct) do
    cond do
      String.match?(struct.request.path, @anchor_matcher) ->
        then(rest, clean_url(struct, struct.request.path))

      true ->
        then(rest, struct)
    end
  end

  defp clean_url(struct, path) do
    new_path = String.replace(path, @anchor_matcher, "")
    Struct.add(struct, :request, %{path: new_path})
  end
end
