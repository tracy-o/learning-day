defmodule Belfrage.RequestTransformers.ElectionBannerCouncilStory do
  use Belfrage.Behaviours.Transformer

  @dial Application.compile_env(:belfrage, :dial)

  @impl Transformer
  def call(envelope = %Envelope{request: %Envelope.Request{raw_headers: raw_headers}}) do
    envelope =
      Envelope.add(envelope, :request, %{
        raw_headers:
          Map.merge(raw_headers, %{
            "election-banner-council-story" => @dial.get_dial(:election_banner_council_story)
          })
      })

    {:ok, envelope}
  end
end
