defmodule Belfrage.Personalisation do
  alias Belfrage.{Struct, RouteSpec}
  alias Belfrage.Struct.{Request, Private}
  alias Belfrage.Authentication.{BBCID, SessionState}

  @dial Application.get_env(:belfrage, :dial)

  def transform_route_spec(spec = %RouteSpec{}) do
    if personalised_route_spec?(spec) do
      %RouteSpec{
        spec
        | personalised_route: true,
          headers_allowlist: spec.headers_allowlist ++ ["x-id-oidc-signedin"],
          cookie_allowlist: spec.cookie_allowlist ++ ["ckns_atkn", "ckns_id"]
      }
    else
      spec
    end
  end

  def personalised_request?(%Struct{request: request = %Request{}, private: private = %Private{}}) do
    private.personalised_route &&
      enabled?() &&
      applicable_request?(request) &&
      SessionState.authenticated?(request)
  end

  def enabled?(opts \\ []) do
    bbc_id = Keyword.get(opts, :bbc_id, BBCID)
    @dial.state(:personalisation) && bbc_id.available?()
  end

  defp production_environment() do
    Application.get_env(:belfrage, :production_environment)
  end

  defp personalised_route_spec?(%RouteSpec{personalisation: personalisation}) do
    case personalisation do
      "on" -> true
      "test_only" -> production_environment() == "test"
      _ -> false
    end
  end

  def applicable_request?(%Request{host: host}) do
    String.ends_with?(host, "bbc.co.uk")
  end
end
