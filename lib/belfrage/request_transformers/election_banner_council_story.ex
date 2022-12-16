defmodule Belfrage.RequestTransformers.ElectionBannerCouncilStory do
  use Belfrage.Behaviours.Transformer

  @dial Application.get_env(:belfrage, :dial)

  @impl Transformer
  def call(struct = %Struct{request: %Struct.Request{raw_headers: raw_headers}}) do
    struct =
      Struct.add(struct, :request, %{
        raw_headers:
          Map.merge(raw_headers, %{
            "election-banner-council-story" => @dial.state(:election_banner_council_story)
          })
      })

    {:ok, struct}
  end
end
