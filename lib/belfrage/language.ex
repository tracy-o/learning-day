defmodule Belfrage.Language do
  alias Belfrage.Struct

  def vary_on_language_cookie(struct) do
    language_from_cookie = struct.private.language_from_cookie

    if language_from_cookie do
      add_language_cookie_to_signature(struct)
    else
      struct
    end
  end

  defp add_language_cookie_to_signature(struct = %Struct{}) do
    signature = struct.private.signature_keys
    add_keys = signature[:add] ++ [:cookie_ckps_language]

    struct
    |> Struct.add(:private, %{signature_keys: %{signature | add: add_keys}})
  end
end
