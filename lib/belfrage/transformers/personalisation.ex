defmodule Belfrage.Transformers.Personalisation do
  use Belfrage.Transformers.Transformer

  alias Belfrage.Struct
  alias Belfrage.Struct.Private
  alias Belfrage.Authentication.SessionState

  @idcta_flagpole Application.get_env(:belfrage, :flagpole)
  @dial Application.get_env(:belfrage, :dial)

  @impl true
  def call(
        rest,
        struct = %Struct{request: %Struct.Request{path: path, raw_headers: headers, cookies: cookies}}
      ) do
    session_state = SessionState.build(cookies, headers, path)
    struct_with_session_state = Struct.add(struct, :user_session, session_state)

    cond do
      !personalisation_available?(struct.request.host) ->
        then(rest, struct)

      match?(%{valid_session: true}, session_state) ->
        then(rest, struct_with_session_state)

      # x-id-oidc-signedin set to 1
      match?(%{session_token: _value, authenticated: true, valid_session: false}, session_state) ->
        redirect(struct_with_session_state)

      # x-id-oidc-signedin not set
      match?(%{session_token: nil, authenticated: false, valid_session: false}, session_state) ->
        then(rest, struct_with_session_state)
    end
  end

  defp personalisation_available?(host) when is_binary(host) do
    @dial.state(:personalisation) && @idcta_flagpole.state() && String.ends_with?(host, "bbc.co.uk")
  end

  defp personalisation_available?(_host) do
    false
  end

  defp redirect(struct = %Struct{}) do
    {
      :redirect,
      Struct.add(struct, :response, %{
        http_status: 302,
        headers: %{
          "location" => redirect_url(struct.request),
          "x-bbc-no-scheme-rewrite" => "1",
          "cache-control" => "private"
        },
        body: "Redirecting"
      })
    }
  end

  defp session_url, do: Application.get_env(:belfrage, :authentication)["session_url"]

  defp redirect_url(request) do
    "#{session_url()}/session?ptrt=#{ptrt(request)}"
  end

  defp ptrt(request) do
    IO.iodata_to_binary([
      to_string(request.scheme),
      "://",
      request.host,
      request.path
    ])
    |> URI.encode_www_form()
    |> Kernel.<>(Belfrage.Helpers.QueryParams.encode(request.query_params, :encoded))
  end
end
