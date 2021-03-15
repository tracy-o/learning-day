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

      iex> BelfrageWeb.Rewriter.rewriteWithoutSlashExtension("/foo/:id/.json")
      "/foo/:id.json"

      iex> BelfrageWeb.Rewriter.rewriteWithoutSlashExtension("/foo/:bar/:id/.json")
      "/foo/:bar/:id.json"

      iex> BelfrageWeb.Rewriter.rewriteWithoutSlashExtension("/foo/:bar/sitemap/.xml")
      "/foo/:bar/sitemap.xml"

      iex> BelfrageWeb.Rewriter.rewriteWithoutSlashExtension("/sport/alpine-skiing/.app")
      "/sport/alpine-skiing.app"

      iex> BelfrageWeb.Rewriter.rewriteWithoutSlashExtension("/foo/:bar/:id")
      "/foo/:bar/:id"

      iex> BelfrageWeb.Rewriter.rewriteWithoutSlashExtension("/news/bundle.js/.map")
      "/news/bundle.js.map"
  """
  def rewriteWithoutSlashExtension(matcher) do
    String.replace(matcher, ~r/\/\.(\w*)$/, ".\\1")
  end
end
