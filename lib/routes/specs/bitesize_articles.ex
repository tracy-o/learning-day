defmodule Routes.Specs.BitesizeArticles do
  def specs("live") do
    %{
      owner: "bitesize-production@lists.forge.bbc.co.uk",
      platform: MorphRouter,
      pipeline: ["BitesizeArticlesPlatformDiscriminator"],
      language_from_cookie: true
    }
  end

  def specs(_production_env) do
    %{
      owner: "bitesize-production@lists.forge.bbc.co.uk",
      platform: MorphRouter,
      pipeline: ["BitesizeTestArticlesPlatformDiscriminator"]
    }
  end
end
