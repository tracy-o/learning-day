defmodule Belfrage.Transformers.UserSession do
  use Belfrage.Transformers.Transformer

  alias Belfrage.Struct
  alias Belfrage.Struct.Private
  @idcta_flagpole Application.get_env(:belfrage, :flagpole)
  @dial Application.get_env(:belfrage, :dial)

  @impl true
  def call(rest, struct = %Struct{request: %Struct.Request{cookies: cookies, raw_headers: headers}}) do
    private = Struct.Private.set_session_state(struct.private, cookies, headers, valid?(cookies["ckns_atkn"]))
    struct_with_session_state = Struct.add(struct, :private, private)

    cond do
      !personalisation_available?() ->
        then(rest, struct)

      match?(%Private{authenticated: true, valid_session: true}, private) ->
        then(rest, struct_with_session_state)

      # x-id-oidc-signedin set to 1
      match?(%Private{session_token: _value, authenticated: true, valid_session: false}, private) ->
        redirect(struct_with_session_state)

      # x-id-oidc-signedin not set
      match?(%Private{session_token: nil, authenticated: false, valid_session: false}, private) ->
        then(rest, struct_with_session_state)
    end
  end

  defp personalisation_available? do
    @dial.state(:personalisation) && @idcta_flagpole.state()
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

  defp valid?(_session_token = nil), do: false

  defp valid?(session_token) do
    case Belfrage.Authentication.Validator.verify_and_validate(session_token) do
      {:ok, _decoded_token} ->
        true

      {:error, [message: message, claim: claim, claim_val: claim_val]} ->
        Belfrage.Event.record(:log, :warn, %{
          msg: "Claim validation failed",
          message: message,
          claim_val: claim_val,
          claim: claim
        })

        false

      {:error, :token_malformed} ->
        Belfrage.Event.record(:log, :error, "Malformed JWT")

        false

      {:error, :public_key_not_found} ->
        false

      {:error, :invalid_token_header} ->
        Belfrage.Event.record(:log, :error, "Invalid token header")

        false

      {:error, :signature_error} ->
        false

      {:error, _} ->
        Belfrage.Event.record(:log, :error, "Unexpected token error.")

        false
    end
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
