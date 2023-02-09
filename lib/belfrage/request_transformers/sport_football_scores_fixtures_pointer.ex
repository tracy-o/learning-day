defmodule Belfrage.RequestTransformers.SportFootballScoresFixturesPointer do
  use Belfrage.Behaviours.Transformer

  @dial Application.compile_env(:belfrage, :dial)

  @impl Transformer
  def call(envelope) do
    if points_to_webcore?() do
      envelope =
        envelope
        |> Envelope.add(:private, %{
          platform: "Webcore",
          origin: Application.get_env(:belfrage, :pwa_lambda_function)
        })

      {:ok, envelope}
    else
      {:ok, envelope}
    end
  end

  defp points_to_webcore? do
    @dial.state(:football_scores_fixtures) == "webcore"
  end
end
