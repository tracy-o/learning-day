defmodule Belfrage.Transformers.UserSession do
  use Belfrage.Transformers.Transformer

  alias __MODULE__.SessionState

  @impl true
  def call(rest, struct = %Struct{request: %Struct.Request{cookies: cookies}}) do
    with :auth_provided <- SessionState.category(cookies),
         {:ok, :valid_session} <- valid?(cookies["ckns_atkn"]) do
      then(
        rest,
        Struct.add(struct, :private, %{
          session_token: cookies["ckns_atkn"],
          authenticated: true,
          valid_session: true
        })
      )
    else
      {:warn, :invalid_session} ->
        redirect(
          Struct.add(struct, :private, %{
            session_token: cookies["ckns_atkn"],
            authenticated: true,
            valid_session: false
          })
        )

      :only_auth_token ->
        redirect(
          Struct.add(struct, :private, %{
            session_token: nil,
            authenticated: false,
            valid_session: false
          })
        )

      :only_identity_token ->
        redirect(
          Struct.add(struct, :private, %{
            session_token: nil,
            authenticated: true,
            valid_session: false
          })
        )

      :no_auth_provided ->
        then(rest, struct)

      :personalisation_disabled ->
        then(rest, struct)
    end
  end

  defp redirect(struct = %Struct{}) do
    {
      :redirect,
      Struct.add(struct, :response, %{
        http_status: 302,
        headers: %{
          "location" => redirect_url(struct.request),
          "x-bbc-no-scheme-rewrite" => "1",
          "cache-control" => "public, stale-while-revalidate=10, max-age=60"
        },
        body: "Redirecting"
      })
    }
  end

  defp valid?(session_token) do
    case Belfrage.Authentication.Validator.verify_and_validate(session_token) do
      {:ok, _decoded_token} ->
        {:ok, :valid_session}

      {:error, [message: message, claim: claim, claim_val: claim_val]} ->
        Belfrage.Event.record(:log, :warn, %{
          msg: "Claim validation failed",
          message: message,
          claim_val: claim_val,
          claim: claim
        })

        {:warn, :invalid_session}

      {:error, :token_malformed} ->
        Belfrage.Event.record(:log, :error, "Malformed JWT")

        {:warn, :invalid_session}

      {:error, :public_key_not_found} ->
        {:warn, :invalid_session}

      {:error, :invalid_token_header} ->
        Belfrage.Event.record(:log, :error, "Invalid token header")

        {:warn, :invalid_session}

      {:error, :signature_error} ->
        {:warn, :invalid_session}

      {:error, _} ->
        Belfrage.Event.record(:log, :error, "Unexpected token error.")

        {:warn, :invalid_session}
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
