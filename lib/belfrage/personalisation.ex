defmodule Belfrage.Personalisation do
  alias Belfrage.{Struct, RouteSpec, Metrics}
  alias Belfrage.Struct.{Request, Private}
  alias Belfrage.Authentication.{BBCID, SessionState}

  @dial Application.get_env(:belfrage, :dial)

  def maybe_put_personalised_route(spec = %RouteSpec{}) do
    if personalised_route_spec?(spec) do
      %RouteSpec{spec | personalised_route: true}
    else
      spec
    end
  end

  def personalised_request?(%Struct{
        request: request = %Request{},
        private: private = %Private{route_state_id: route_state_id}
      }) do
    private.personalised_route &&
      enabled?(route_state_id: route_state_id) &&
      applicable_request?(request) &&
      SessionState.authenticated?(request)
  end

  def enabled?(opts \\ []) do
    route_state_id = Keyword.get(opts, :route_state_id, :no_route_state_id)
    bbc_id = Keyword.get(opts, :bbc_id, BBCID)

    case route_state_id do
      "PersonalisedContainerData" ->
        @dial.state(:news_articles_personalisation) && @dial.state(:personalisation) && bbc_id.available?()

      _ ->
        @dial.state(:personalisation) && bbc_id.available?()
    end
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

  def maybe_put_personalised_request(struct = %Struct{}) do
    Metrics.duration(:check_if_personalised_request, fn ->
      if personalised_request?(struct) do
        Struct.add(struct, :private, %{personalised_request: true})
      else
        struct
      end
    end)
  end

  def append_allowlists(struct = %Struct{}) do
    cond do
      append_allowlists_for_web_request?(struct) ->
        Struct.add(struct, :private, %{
          headers_allowlist: struct.private.headers_allowlist ++ ["x-id-oidc-signedin"],
          cookie_allowlist: struct.private.cookie_allowlist ++ ["ckns_atkn", "ckns_id"]
        })

      append_allowlists_for_app_request?(struct) ->
        Struct.add(struct, :private, %{
          headers_allowlist: struct.private.headers_allowlist ++ ["authorization", "x-authentication-provider"]
        })

      true ->
        struct
    end
  end

  defp append_allowlists_for_app_request?(struct = %Struct{}) do
    struct.private.personalised_route and struct.request.app?
  end

  defp append_allowlists_for_web_request?(struct = %Struct{}) do
    struct.private.personalised_route and not struct.request.app?
  end
end
