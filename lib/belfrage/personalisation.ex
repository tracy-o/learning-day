defmodule Belfrage.Personalisation do
  alias Belfrage.Struct
  alias Belfrage.Struct.{Request, Private}
  alias Belfrage.RouteSpec
  alias Belfrage.Authentication.SessionState

  @dial Application.get_env(:belfrage, :dial)
  @idcta_flagpole Application.get_env(:belfrage, :flagpole)

  def personalised_request?(%Struct{request: request = %Request{}, private: private = %Private{}}) do
    RouteSpec.Personalisation.personalised?(private.loop_id) &&
      enabled?() &&
      applicable_request?(request) &&
      SessionState.authenticated?(request)
  end

  def enabled?() do
    @dial.state(:personalisation) && @idcta_flagpole.state()
  end

  defp applicable_request?(%Request{host: host}) do
    String.ends_with?(host, "bbc.co.uk")
  end
end
