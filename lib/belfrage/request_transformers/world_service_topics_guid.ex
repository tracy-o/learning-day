defmodule Belfrage.RequestTransformers.WorldServiceTopicsGuid do
  use Belfrage.Transformer

  def call(rest, struct) do
    if topics_guid?(struct) do
      then_do(
        rest,
        Struct.add(struct, :private, %{
          platform: MozartNews,
          origin: Application.get_env(:belfrage, :mozart_news_endpoint)
        })
      )
    else
      then_do(rest, struct)
    end
  end

  defp topics_guid?(struct) do
    if struct.request.path_params["id"] do
      String.length(struct.request.path_params["id"]) != 12
    else
      false
    end
  end
end
