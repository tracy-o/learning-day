defmodule Belfrage.Transformers.PersonalisedToNonPersonalised do
  use Belfrage.Transformers.Transformer

  def call(_rest, struct) do
    then_do(
      [],
      Struct.add(struct, :private, %{
        platform: MozartNews,
        origin: Application.get_env(:belfrage, :mozart_news_endpoint),
        personalised_route: false,
        personalised_request: false
      })
    )
  end
end
