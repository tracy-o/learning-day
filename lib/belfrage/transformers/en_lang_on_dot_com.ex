defmodule Belfrage.Transformers.EnLangOnDotCom do
  use Belfrage.Transformers.Transformer

  @impl true
  def call(rest, struct) do
    then(
      rest,
      Belfrage.Struct.add(struct, :request, %{language: default_language(struct)})
    )
  end

  defp default_language(struct) do
    case String.ends_with?(struct.request.host, ".com") do
      true ->
        "en"

      false ->
        nil
    end
  end
end
