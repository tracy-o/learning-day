defmodule Belfrage.Transformers.UserSession do
  use Belfrage.Transformers.Transformer

  # note: `Plug.Conn.Cookies.decode` benchmark
  # https://github.com/bbc/belfrage/pull/574#issuecomment-715417312
  import Plug.Conn.Cookies, only: [decode: 1]

  @flagpole Application.get_env(:belfrage, :flagpole)

  @impl true
  def call(rest, struct = %Struct{request: %Struct.Request{raw_headers: %{"cookie" => cookie}}}) do
    case @flagpole.state() do
      true ->
        %{struct | private: handle_cookies(decode(cookie), struct.private) |> valid?()}
        |> maybe_redirect(rest)

      false ->
        then(rest, struct)
    end
  end

  def call(rest, struct), do: then(rest, struct)

  defp maybe_redirect(struct = %Struct{private: %Struct.Private{valid_session: false}}, _rest) do
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

  defp maybe_redirect(struct = %Struct{private: %Struct.Private{valid_session: true}}, rest), do: then(rest, struct)

  defp valid?(private_struct = %Struct.Private{session_token: nil}) do
    %{private_struct | valid_session: false}
  end

  defp valid?(private_struct = %Struct.Private{authenticated: true, session_token: token}) do
    case Belfrage.Authentication.Validator.verify_and_validate(token) do
      {:ok, _decoded_token} ->
        %{private_struct | valid_session: true}

      {:error, [message: message, claim: claim, claim_val: claim_val]} ->
        Belfrage.Event.record(:log, :warn, %{
          msg: "Claim validation failed",
          message: message,
          claim_val: claim_val,
          claim: claim
        })

        %{private_struct | valid_session: false}

      {:error, :token_malformed} ->
        Belfrage.Event.record(:log, :error, "Malformed JWT")
        %{private_struct | valid_session: false}

      {:error, :public_key_not_found} ->
        %{private_struct | valid_session: false}

      {:error, :invalid_token_header} ->
        Belfrage.Event.record(:log, :error, "Invalid token header")
        %{private_struct | valid_session: false}

      {:error, :signature_error} ->
        %{private_struct | valid_session: false}

      {:error, _} ->
        Belfrage.Event.record(:log, :error, "Unexpected token error.")
        %{private_struct | valid_session: false}
    end
  end

  defp valid?(private_struct), do: private_struct

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

  defp handle_cookies(decoded_cookies, private_struct)

  defp handle_cookies(%{"ckns_id" => _, "ckns_atkn" => token}, private_struct) do
    %{private_struct | authenticated: true, session_token: token}
  end

  defp handle_cookies(%{"ckns_id" => _}, private_struct), do: %{private_struct | authenticated: true}
  defp handle_cookies(_cookies, private_struct), do: private_struct
end
