defmodule Belfrage.Transformers.ElectionBannerCouncilStory do
    use Belfrage.Transformers.Transformer
    alias Belfrage.Struct
  
    @dial Application.get_env(:belfrage, :dial)
  
    def call(rest, struct = %Struct{request: %Struct.Request{raw_headers: raw_headers}}) do
      struct =
        Struct.add(struct, :request, %{
          raw_headers:
            Map.merge(raw_headers, %{
              "election-banner-council-story" => @dial.state(:election_banner_council_story)
            })
        })
  
      then_do(rest, struct)
    end
  end
  