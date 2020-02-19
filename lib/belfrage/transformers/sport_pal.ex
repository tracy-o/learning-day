defmodule Belfrage.Transformers.SportPal do
  use Belfrage.Transformers.Transformer

  @end_of_path_pal_matcher ~r/\/pal(?=$|\.)/

  @impl true
  def call(rest, struct) do
    cond do
      String.match?(struct.request.path, @end_of_path_pal_matcher) ->
        struct = clean_url(struct, struct.request.path)
        then(rest, struct)

      true ->
        then(rest, struct)
    end
  end

  defp clean_url(struct, path) do
    new_path = String.replace(path, @end_of_path_pal_matcher, "")
    Struct.add(struct, :request, %{path: new_path})
  end
end
