defmodule Belfrage.Brands do
  alias Belfrage.Envelope

  @dial Application.compile_env(:belfrage, :dial)

  @allowed_countries ["us", "ca"]

  def is_bbcx?(%Envelope{request: request, private: %Envelope.Private{production_environment: prod_env}}) do
    prod_env == "test" and
      @dial.state(:bbcx_enabled) and
      String.ends_with?(request.host, "bbc.com") and
      Map.get(request.raw_headers, "cookie-ckns_bbccom_beta") == "1" and
      request.country in @allowed_countries
  end
end
