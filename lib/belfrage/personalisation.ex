defmodule Belfrage.Personalisation do
  alias Belfrage.{Envelope, Metrics}
  alias Belfrage.Envelope.{Request, Private}
  alias Belfrage.Authentication.{BBCID, SessionState}

  @dial Application.compile_env(:belfrage, :dial)

  def maybe_put_personalised_route(spec = %{personalisation: personalisation}) do
    if personalised_route_spec?(personalisation) do
      %{spec | personalised_route: true}
    else
      spec
    end
  end

  def personalised_request?(%Envelope{
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
      {"PersonalisedContainerData", "Webcore"} -> news_articles_personalised?(bbc_id)
      {"PersonalisedContainerData", "Webcore", _} -> news_articles_personalised?(bbc_id)
      _ -> @dial.get_dial(:personalisation) && bbc_id.available?()
    end
  end

  defp news_articles_personalised?(bbc_id) do
    @dial.get_dial(:news_articles_personalisation) && @dial.get_dial(:personalisation) && bbc_id.available?()
  end

  defp production_environment() do
    Application.get_env(:belfrage, :production_environment)
  end

  defp personalised_route_spec?(personalisation) do
    case personalisation do
      "on" -> true
      "test_only" -> production_environment() == "test"
      _ -> false
    end
  end

  def applicable_request?(%Request{host: host}) do
    String.ends_with?(host, "bbc.co.uk")
  end

  def maybe_put_personalised_request(envelope = %Envelope{}) do
    Metrics.latency_span(:check_if_personalised_request, fn ->
      if personalised_request?(envelope) do
        Envelope.add(envelope, :private, %{personalised_request: true})
      else
        envelope
      end
    end)
  end

  def append_allowlists(envelope = %Envelope{}) do
    cond do
      append_allowlists_for_web_request?(envelope) ->
        Envelope.add(envelope, :private, %{
          headers_allowlist: envelope.private.headers_allowlist ++ ["x-id-oidc-signedin"],
          cookie_allowlist: envelope.private.cookie_allowlist ++ ["ckns_atkn", "ckns_id"]
        })

      append_allowlists_for_app_request?(envelope) ->
        Envelope.add(envelope, :private, %{
          headers_allowlist: envelope.private.headers_allowlist ++ ["authorization", "x-authentication-provider"]
        })

      true ->
        envelope
    end
  end

  defp append_allowlists_for_app_request?(envelope = %Envelope{}) do
    envelope.private.personalised_route and envelope.request.app?
  end

  defp append_allowlists_for_web_request?(envelope = %Envelope{}) do
    envelope.private.personalised_route and not envelope.request.app?
  end
end
