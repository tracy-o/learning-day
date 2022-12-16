defmodule Belfrage.RequestTransformers.NewsArticleValidator do
  use Belfrage.Behaviours.Transformer

  @impl Transformer
  def call(struct) do
    if joan_belfrage_stack?() or valid_article_id?(struct) do
      {:ok, struct}
    else
      {:stop, Struct.put_status(struct, 404)}
    end
  end

  defp joan_belfrage_stack?() do
    Application.get_env(:belfrage, :stack_id) == "joan"
  end

  defp valid_article_id?(struct) do
    case struct.request.path_params["id"] do
      nil -> false
      id -> String.match?(id, ~r/^([a-zA-Z0-9\+]+-)*[0-9]{4,9}$/)
    end
  end
end
