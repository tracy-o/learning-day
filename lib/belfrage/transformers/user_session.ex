defmodule Belfrage.Transformers.UserSession do
  use Belfrage.Transformers.Transformer

  alias Belfrage.Struct
  alias Belfrage.Struct.Private
  @idcta_flagpole Application.get_env(:belfrage, :flagpole)
  @dial Application.get_env(:belfrage, :dial)

  @impl true
  def call(rest, struct = %Struct{request: %Struct.Request{cookies: cookies, raw_headers: headers}}) do
    decoded_token = decode_token(cookies["ckns_atkn"])

    private = Struct.Private.set_session_state(struct.private, cookies, headers, valid?(decoded_token))
    struct_with_session_state = Struct.add(struct, :private, private)

    cond do
      !personalisation_available?(struct.request.host) ->
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

  defp decode_token(nil) do
    nil
  end

  defp decode_token(cookie) do
    Belfrage.Authentication.Validator.verify_and_validate(cookie)
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

  defp valid?(_decoded_token = nil), do: false

  defp valid?({:ok, _decoded_token}) do
    true
  end

  defp valid?({:error, [message: message, claim: claim, claim_val: claim_val]}) do
    Belfrage.Event.record(:log, :warn, %{
          msg: "Claim validation failed",
          message: message,
          claim_val: claim_val,
          claim: claim })

    false
  end

  defp valid?({:error, :token_malformed}) do
    Belfrage.Event.record(:log, :error, "Malformed JWT")

    false
  end

  defp valid?({:error, :public_key_not_found}) do
    false
  end

  defp valid?({:error, :invalid_token_header}) do
    Belfrage.Event.record(:log, :error, "Invalid token header")

    false
  end


  defp valid?({:error, :signature_error}) do
    false
  end

  defp valid?({:error, _}) do
    Belfrage.Event.record(:log, :error, "Unexpected token error.")

    false
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
