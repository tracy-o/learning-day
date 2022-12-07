defmodule Belfrage.RequestTransformers.SportFootballScoresFixturesPointer do
  use Belfrage.Behaviours.Transformer

  @dial Application.get_env(:belfrage, :dial)

  @impl Transformer
  def call(struct) do
    if points_to_webcore?() do
      struct =
        struct
        |> Struct.add(:private, %{
          platform: Webcore,
          origin: Application.get_env(:belfrage, :pwa_lambda_function)
        })

      {:ok, struct}
    else
      {:ok, struct}
    end
  end

  defp points_to_webcore? do
    @dial.state(:football_scores_fixtures) == "webcore"
  end
end
