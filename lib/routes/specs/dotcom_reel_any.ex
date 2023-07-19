defmodule Routes.Specs.DotComReelAny do
  def specification do
    %{
      specs: %{
        platform: "DotComReel",
        examples: ["/reel", "/reel/playlists", "/reel/playlist/musical-lives"]
      }
    }
  end
end
