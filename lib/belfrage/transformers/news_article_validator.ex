defmodule Belfrage.Transformers.NewsArticleValidator do
  use Belfrage.Transformers.Transformer

  @impl true
  def call(rest, struct) do
    if joan_belfrage_stack?() or valid_article_id?(struct) do
      then_do(rest, struct)
    else
      {:stop_pipeline, Struct.put_status(struct, 404)}
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
