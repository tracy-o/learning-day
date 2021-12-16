defmodule Routes.Specs.BitesizeArticles do
  def specs("live") do
    %{
      owner: "bitesize-production@lists.forge.bbc.co.uk",
      platform: Webcore,
      pipeline: ["BitesizeArticlesPlatformDiscriminator"],
    }
  end

  def specs(_production_env) do
    %{
      owner: "bitesize-production@lists.forge.bbc.co.uk",
      platform: Webcore,
      pipeline: ["BitesizeArticlesPlatformDiscriminator"],
      language_from_cookie: true
    }
  end
end
