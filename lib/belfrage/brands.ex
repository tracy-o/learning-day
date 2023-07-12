defmodule Belfrage.Brands do
  alias Belfrage.Envelope

  @dial Application.compile_env(:belfrage, :dial)

  @allowed_countries ["us", "as", "gu", "mp", "pr", "vi", "ca"]

  def bbcx_enabled? do
    @dial.state(:bbcx_enabled)
  end

  def is_bbcx?(%Envelope{request: request}) do
    request.country in @allowed_countries and
      String.ends_with?(request.host, "bbc.com") and
      Map.get(request.raw_headers, "cookie-ckns_bbccom_beta") == "1" and
      @dial.state(:bbcx_enabled)
  end
end
