defmodule Belfrage.RequestTransformers.PersonalisedToNonPersonalised do
  use Belfrage.Behaviours.Transformer

  @impl Transformer
  def call(struct) do
    {
      :ok,
      Struct.add(struct, :private, %{
        platform: "MozartNews",
        origin: Application.get_env(:belfrage, :mozart_news_endpoint),
        personalised_route: false,
        personalised_request: false
      })
    }
  end
end
