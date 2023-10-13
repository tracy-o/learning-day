defmodule Belfrage.PreflightTransformers.SportFootballScoresFixturesPointer do
  use Belfrage.Behaviours.Transformer

  @dial Application.compile_env(:belfrage, :dial)

  @impl Transformer
  def call(envelope) do
    {:ok, Envelope.add(envelope, :private, %{platform: get_platform()})}
  end

  defp points_to_webcore? do
    @dial.get_dial(:football_scores_fixtures) == "webcore"
  end

  defp get_platform() do
    if points_to_webcore?() do
      "Webcore"
    else
      "MozartSport"
    end
  end
end
