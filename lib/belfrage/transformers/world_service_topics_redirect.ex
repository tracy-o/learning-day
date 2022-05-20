defmodule Belfrage.Transformers.WorldServiceTopicsRedirect do
  use Belfrage.Transformers.Transformer

  def call(rest, struct) do
    if redirect_to_mozart?(struct) do
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

  defp redirect_to_mozart?(struct) do
    !String.match?(struct.request.path, ~r/^\/[[:alnum:]]+\/topics\/[[:alnum:]]{12}\?{0,1}/)
  end
end
