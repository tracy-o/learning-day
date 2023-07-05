defmodule Routes.Specs.DotComReelAny do
  def specification do
    %{
      specs: %{
        platform: "DotComReel",
        examples: ["/reel/playlists", "/reel/playlist/musical-lives"]
      }
    }
  end
end
