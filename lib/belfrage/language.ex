defmodule Belfrage.Language do
  alias Belfrage.Envelope

  def add_signature(envelope) do
    if envelope.private.language_from_cookie do
      add_cookie_to_signature(envelope)
    else
      envelope
    end
  end

  def set(envelope) do
    language_from_cookie = envelope.private.language_from_cookie
    cookie_ckps_language = envelope.request.cookie_ckps_language
    default_language = envelope.private.default_language

    case {language_from_cookie, cookie_ckps_language} do
      {true, "cy"} -> "cy"
      {true, "ga"} -> "ga"
      {true, "gd"} -> "gd"
      {true, "en"} -> "en-GB"
      _ -> default_language
    end
  end

  def vary(headers, envelope) do
    if envelope.private.language_from_cookie do
      ["cookie-ckps_language" | headers]
    else
      headers
    end
  end

  defp add_cookie_to_signature(envelope = %Envelope{}) do
    signature = envelope.private.signature_keys
    add_keys = signature[:add] ++ [:cookie_ckps_language]

    envelope
    |> Envelope.add(:private, %{signature_keys: %{signature | add: add_keys}})
  end
end
