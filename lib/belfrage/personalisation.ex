defmodule Belfrage.Personalisation do
  alias Belfrage.Struct
  alias Belfrage.Struct.{Request, Private}
  alias Belfrage.Authentication.{BBCID, SessionState}

  @route_spec_attrs %{cookie_allowlist: ["ckns_atkn", "ckns_id"], headers_allowlist: ["x-id-oidc-signedin"]}
  @dial Application.get_env(:belfrage, :dial)

  def transform_route_spec(spec) do
    if personalised_route_spec?(spec) do
      spec
      |> Map.put(:personalised_route, true)
      |> Map.merge(@route_spec_attrs, fn _key, v1, v2 -> v1 ++ v2 end)
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

  defp personalised_route_spec?(spec) do
    case spec[:personalisation] do
      "on" -> true
      "test_only" -> production_environment() == "test"
      _ -> false
    end
  end

  def applicable_request?(%Request{host: host}) do
    String.ends_with?(host, "bbc.co.uk")
  end
end
