defmodule Belfrage.Transformers.Language do
  use Belfrage.Transformers.Transformer

  @impl true
  def call(rest, struct) do
    # TODO
    # We use the naming `default_language` in the route spec, to future-proof the tenant's API, so
    # that when Belfrage has logic to set the language depending on a cookie for webcore requests,
    # we don't have to change `language` to `default_language` in the route specs, as it's already done.
    #
    # The logic to use a cookie/header language instead of the default, will be done in this
    # request transformer.

    language_from_cookie = struct.private.lanaguage_from_cookie
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
