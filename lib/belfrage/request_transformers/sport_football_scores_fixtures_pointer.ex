defmodule Belfrage.RequestTransformers.SportFootballScoresFixturesPointer do
  use Belfrage.Transformer

  @dial Application.get_env(:belfrage, :dial)

  @impl true
  def call(rest, struct) do
    if point_to_webcore?() do
      struct =
        struct
        |> Struct.add(:private, %{
          platform: Webcore,
          origin: Application.get_env(:belfrage, :webcore_endpoint)
        })

      then_do(rest, struct)
    else
      then_do(rest, struct)
    end
  end

  defp point_to_webcore? do
    @dial.state(:football_scores_fixtures) == "webcore"
  end
end
