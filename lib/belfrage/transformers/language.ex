defmodule Belfrage.Transformers.Language do
  use Belfrage.Transformers.Transformer

  @impl true
  def call(rest, struct) do
    language_from_cookie = struct.private.language_from_cookie
    cookie_ckps_language = struct.request.cookie_ckps_language
    default_language = struct.private.default_language

    lang =
      case {language_from_cookie, cookie_ckps_language} do
        {false, _} -> default_language
        {true, "cy"} -> "cy"
        {true, "ga"} -> "ga"
        {true, "gd"} -> "gd"
        {true, "en"} -> "en-GB"
        {true, _} -> default_language
      end

    then(
      rest,
      Belfrage.Struct.add(struct, :request, %{language: lang})
    )
  end
end
