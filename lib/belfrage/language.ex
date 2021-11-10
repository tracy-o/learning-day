defmodule Belfrage.Language do
  alias Belfrage.Struct

  def add_signature(struct) do
    if struct.private.language_from_cookie do
      add_cookie_to_signature(struct)
    else
      struct
    end
  end

  def set(struct) do
    language_from_cookie = struct.private.language_from_cookie
    cookie_ckps_language = struct.request.cookie_ckps_language
    default_language = struct.private.default_language

    case {language_from_cookie, cookie_ckps_language} do
      {true, "cy"} -> "cy"
      {true, "ga"} -> "ga"
      {true, "gd"} -> "gd"
      {true, "en"} -> "en-GB"
      _ -> default_language
    end
  end

  def vary(headers, struct) do
    if struct.private.language_from_cookie do
      ["cookie-ckps_language" | headers]
    else
      headers
    end
  end

  defp add_cookie_to_signature(struct = %Struct{}) do
    signature = struct.private.signature_keys
    add_keys = signature[:add] ++ [:cookie_ckps_language]

    struct
    |> Struct.add(:private, %{signature_keys: %{signature | add: add_keys}})
  end
end
