defmodule BelfrageWeb.Rewriter do
  @doc """
  Rewrites Routefile matchers including `.format` to a structure copying
  with the Plug by-design limitations.

  ## Examples

      iex> BelfrageWeb.Rewriter.rewrite("/foo/:id.json")
      "/foo/:id/.json"

      iex> BelfrageWeb.Rewriter.rewrite("/foo/:bar/:id.json")
      "/foo/:bar/:id/.json"

      iex> BelfrageWeb.Rewriter.rewrite("/foo/:bar/sitemap.xml")
      "/foo/:bar/sitemap/.xml"

      iex> BelfrageWeb.Rewriter.rewrite("/sport/alpine-skiing.app")
      "/sport/alpine-skiing/.app"

      iex> BelfrageWeb.Rewriter.rewrite("/foo/:bar/:id")
      "/foo/:bar/:id"

      iex> BelfrageWeb.Rewriter.rewrite("/news/bundle.js.map")
      "/news/bundle.js/.map"
  """
  def rewrite(matcher) do
    String.replace(matcher, ~r/\.(\w*)$/, "/.\\1")
  end

  @doc """
  Rewrites Routefile matchers rewritten by the above function back to the original matcher string

  ## Examples

      iex> BelfrageWeb.Rewriter.rewrite_without_slash_extension("/foo/:id/.json")
      "/foo/:id.json"

      iex> BelfrageWeb.Rewriter.rewrite_without_slash_extension("/foo/:bar/:id/.json")
      "/foo/:bar/:id.json"

      iex> BelfrageWeb.Rewriter.rewrite_without_slash_extension("/foo/:bar/sitemap/.xml")
      "/foo/:bar/sitemap.xml"

      iex> BelfrageWeb.Rewriter.rewrite_without_slash_extension("/sport/alpine-skiing/.app")
      "/sport/alpine-skiing.app"

      iex> BelfrageWeb.Rewriter.rewrite_without_slash_extension("/foo/:bar/:id")
      "/foo/:bar/:id"

      iex> BelfrageWeb.Rewriter.rewrite_without_slash_extension("/news/bundle.js/.map")
      "/news/bundle.js.map"
  """
  def rewrite_without_slash_extension(matcher) do
    String.replace(matcher, ~r/\/\.(\w*)$/, ".\\1")
  end
end
